require_relative "game_test"

class TapLandTest < GameTest

  def untapped_land
    result = @duel.player1.battlefield.select { |b| !b.entity.is_tapped? && b.entity.find_card.is_land? }

    fail "No untapped land found: #{result}" unless result.first and result.first != nil
    return result.first
  end

  test "we can tap forests to get green mana" do
    @duel.phase = Duel.playing_phase

    assert_equal 0, @duel.player1.mana_green
    assert_equal @duel.player1, untapped_land.player, @duel.player1.mana

    game_engine.card_action(untapped_land, "tap")
    assert_equal 1, @duel.player1.mana_green, @duel.player1.mana

    game_engine.card_action(untapped_land, "tap")
    assert_equal 2, @duel.player1.mana_green, @duel.player1.mana
  end

  test "we can tap cards" do
    @duel.phase = Duel.playing_phase

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
    @duel.phase = Duel.playing_phase

    card = untapped_land
    assert !card.entity.is_tapped?
    card.entity.tap_card!
    assert card.entity.is_tapped?
  end

  test "we can tap cards directly through entity" do
    @duel.phase = Duel.playing_phase

    entity = untapped_land.entity
    assert !entity.is_tapped?
    entity.tap_card!
    assert entity.is_tapped?
  end

end
