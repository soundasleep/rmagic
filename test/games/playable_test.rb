require_relative "game_test"

class PlayableTest < GameTest

  def setup
    super

    @duel.phase = Duel.playing_phase
    @duel.save!

    assert_equal [], @duel.player1.hand

    creature = Entity.create!( metaverse_id: 1 )
    Hand.create!( player: @duel.player1, entity: creature )
  end

  def hand
    Hand.where(player: @duel.player1)
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

  test "we have three green lands to tap" do
    tap_all_lands
    assert_equal 3, @duel.player1.mana_green
  end

  test "with tapping, we can play a creature" do
    tap_all_lands

    assert_equal [
      hand.first!.entity
    ], game_engine.available_actions[:play].map { |h| h.entity }
  end

  test "playing a creature creates an action" do
    tap_all_lands

    card = hand.first!
    game_engine.play(card)

    action = Action.where(duel: @duel).last
    assert_equal card.entity, action.entity
    assert_equal "play", action.entity_action
  end

  def battlefield_creatures
    @duel.player1.battlefield.select{ |b| !b.entity.find_card.is_land? }.map{ |b| b.entity }
  end

  test "playing a creature puts a creature on the battlefield" do
    tap_all_lands

    assert_equal [], battlefield_creatures

    assert_equal 3, @duel.player1.mana_green
    card = hand.first!
    game_engine.play(card)

    assert_equal [card.entity], battlefield_creatures
  end

end
