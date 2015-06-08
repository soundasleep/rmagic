require_relative "game_test"

class TapLandTest < GameTest

  def setup
    super

    @duel.phase = Duel.playing_phase
    @duel.save!
  end

  def untapped_land
    result = @duel.player1.battlefield.select { |b| !b.entity.is_tapped? && b.entity.find_card.is_land? }

    fail "No untapped land found: #{result}" unless result.first and result.first != nil
    return result.first
  end

  test "we can tap forests to get green mana" do
    assert_equal 0, @duel.player1.mana_green
    assert_equal @duel.player1, untapped_land.player, @duel.player1.mana

    game_engine.card_action(untapped_land, "tap")
    assert_equal 1, @duel.player1.mana_green, @duel.player1.mana

    game_engine.card_action(untapped_land, "tap")
    assert_equal 2, @duel.player1.mana_green, @duel.player1.mana
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
    assert_equal Duel.playing_phase, @duel.phase
  end

  test "tapping creates an action" do
    assert_equal [], Action.where(duel: @duel)

    card = untapped_land
    game_engine.card_action(card, "tap")

    action = Action.where(duel: @duel).first!
    assert_equal card.entity, action.entity
  end

end
