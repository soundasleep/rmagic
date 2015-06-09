require_relative "game_test"

class PlayableTest < GameTest

  def setup
    super

    @duel.phase_number = Duel.playing_phase
    @duel.save!

    assert_equal [], @duel.player1.hand

    creature = Entity.create!( metaverse_id: 1 )
    Hand.create!( player: @duel.player1, entity: creature )
  end

  def hand
    Hand.where(player: @duel.player1)
  end

  def available_actions
    game_engine.available_actions(@duel.player1)
  end

  test "without tapping, we can't play anything" do
    assert_equal [], available_actions[:play]
  end

  test "we have three green lands to tap" do
    tap_all_lands
    assert_equal 3, @duel.player1.mana_green
  end

  test "with tapping, we can play a creature" do
    tap_all_lands

    assert_equal [
      hand.first!.entity
    ], available_actions[:play].map { |h| h.entity }
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

  def battlefield_can_be_tapped
    available_actions[:tap].map{ |b| b.entity }
  end

  test "lands can be tapped" do
    assert_equal @duel.player1.battlefield.map{ |b| b.entity }, battlefield_can_be_tapped
  end

  test "after lands are tapped, lands cannot be retapped" do
    tap_all_lands
    assert_equal [], battlefield_can_be_tapped
  end

  test "creatures cannot be tapped" do
    tap_all_lands
    create_creatures
    assert_equal [], battlefield_can_be_tapped
  end

  test "we can't play a creature if it's not our turn" do
    @duel.current_player_number = 2
    @duel.save!

    assert_equal [], available_actions[:play].map { |h| h.entity }
  end

  test "we can't play a creature if it's not our priority, even with tapping" do
    @duel.priority_player_number = 2
    @duel.save!

    tap_all_lands

    assert_equal [], available_actions[:play].map { |h| h.entity }
  end

  test "we can't play a creature if it's not our turn, even with tapping" do
    @duel.current_player_number = 2
    @duel.save!

    tap_all_lands

    assert_equal [], available_actions[:play].map { |h| h.entity }
  end

end
