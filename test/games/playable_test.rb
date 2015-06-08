require_relative "game_test"

class PlayableTest < GameTest

  def first_deck_entity(player)
    fail "no entity found" unless player.deck.first.entity
    player.deck.first.entity
  end

  test "without tapping, we can't play anything" do
    @duel.phase = Duel.playing_phase
    Hand.create!( player: @duel.player1, entity: first_deck_entity(@duel.player1) )

    assert_equal [], game_engine.available_actions[:play]
  end

  test "with tapping, we can play a creature" do
    @duel.phase = Duel.playing_phase
    hand = Hand.create!( player: @duel.player1, entity: first_deck_entity(@duel.player1) )

    # tap all battlefield lands
    @duel.player1.battlefield.select { |b| b.entity.find_card.is_land? }.each do |b|
      game_engine.card_action(b, "tap")
    end

    assert_equal [
      hand.entity
    ], game_engine.available_actions[:play].map { |h| h.entity }
  end

end
