require_relative "game_test"

class PlayableTest < GameTest

  def setup
    super

    @duel.phase = Duel.playing_phase
    @duel.save!

    @hand = Hand.create!( player: @duel.player1, entity: first_deck_entity(@duel.player1) )
  end

  def first_deck_entity(player)
    fail "no entity found" unless player.deck.first.entity
    player.deck.first.entity
  end

  test "without tapping, we can't play anything" do
    assert_equal [], game_engine.available_actions[:play]
  end

  def tap_all_lands
    # tap all battlefield lands
    @duel.player1.battlefield.select { |b| b.entity.find_card.is_land? }.each do |b|
      game_engine.card_action(b, "tap")
    end

  end

  test "with tapping, we can play a creature" do
    tap_all_lands

    assert_equal [
      @hand.entity
    ], game_engine.available_actions[:play].map { |h| h.entity }
  end

  test "playing a creature creates an action" do
    tap_all_lands

    game_engine.play(@hand)

    action = Action.where(duel: @duel).last
    assert_equal @hand.entity, action.entity
    assert_equal "play", action.entity_action
  end

  def battlefield_creatures
    @duel.player1.battlefield.select{ |b| !b.entity.find_card.is_land? }.map{ |b| b.entity }
  end

  test "playing a creature puts a creature on the battlefield" do
    tap_all_lands

    assert_equal [], battlefield_creatures

    game_engine.play(@hand)

    assert_equal [@hand.entity], battlefield_creatures
  end

end
