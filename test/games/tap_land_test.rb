require_relative "game_test"

class TapLandTest < GameTest

  def setup
    super

    @duel.phase_number = Duel.playing_phase
    @duel.save!
  end

  def untapped_land
    result = untapped_lands

    fail "No untapped land found: #{result}" unless result.first and result.first != nil
    return result.first
  end

  def untapped_lands
    @duel.player1.battlefield.select { |b| !b.entity.is_tapped? && b.entity.find_card.is_land? }
  end

  test "we can tap forests to get green mana" do
    assert_equal 0, @duel.player1.mana_green
    assert_equal @duel.player1, untapped_land.player

    game_engine.card_action(untapped_land, "tap")
    assert_equal 1, @duel.player1.mana_green

    game_engine.card_action(untapped_land, "tap")
    assert_equal 2, @duel.player1.mana_green
  end

  test "updated mana is synchronised" do
    land = untapped_land
    game_engine.card_action(land, "tap")
    assert_equal 1, @duel.player1.mana_green
    assert_equal 1, land.player.mana_green
  end

  test "we can tap cards" do
    card = untapped_land
    assert !card.entity.is_tapped?
    game_engine.card_action(card, "tap")
    card.reload
    card.entity.reload
    assert card.entity.is_tapped?

    # we have another untapped land
    card = untapped_land
    assert !card.entity.is_tapped?
  end

  test "we can tap cards directly" do
    card = untapped_land
    assert !card.entity.is_tapped?
    card.entity.tap_card!
    assert card.entity.is_tapped?
  end

  test "we can tap cards directly through entity" do
    entity = untapped_land.entity
    assert !entity.is_tapped?
    entity.tap_card!
    assert entity.is_tapped?
  end

  test "tapping does not modify duel phase" do
    game_engine.card_action(untapped_land, "tap")
    assert_equal Duel.playing_phase, @duel.phase_number
  end

  test "tapping creates an action" do
    assert_equal [], Action.where(duel: @duel)

    card = untapped_land
    game_engine.card_action(card, "tap")

    action = Action.where(duel: @duel).first!
    assert_equal card.entity, action.entity
  end

  test "tapped lands untap in the next turn" do
    tap_all_lands
    assert_equal [], untapped_lands

    pass_until_next_turn
    assert_not_equal [], untapped_lands
  end

  test "tapped lands do not untap in the next players current turn" do
    tap_all_lands
    assert_equal [], untapped_lands
    turn = @duel.turn

    pass_until_next_player
    assert_equal [], untapped_lands
    assert_equal turn, @duel.turn

    pass_until_next_player
    assert_not_equal [], untapped_lands
    assert_not_equal turn, @duel.turn
  end

  test "tapped mana disappears after a pass" do
    assert_equal 0, @duel.player1.mana_green

    tap_all_lands
    assert_equal 3, @duel.player1.mana_green

    game_engine.pass

    assert_equal 0, @duel.player1.mana_green
  end

end
