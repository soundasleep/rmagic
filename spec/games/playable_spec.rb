require_relative "setup_game"

RSpec.describe "Playable" do
  before :each do
    setup

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

  it "without tapping, we can't play anything" do
    expect(available_actions[:play]).to be_empty
  end

  it "we have three green lands to tap" do
    tap_all_lands
    expect(@duel.player1.mana_green).to eq(3)
  end

  it "with tapping, we can play a creature" do
    tap_all_lands

    expect(available_actions[:play].map { |h| h.entity }).to eq([hand.first!.entity])
  end

  it "playing a creature creates an action" do
    tap_all_lands

    card = hand.first!
    game_engine.play(card)

    action = Action.where(duel: @duel).last
    expect(action.entity).to eq(card.entity)
    expect(action.entity_action).to eq("play")
  end

  def battlefield_creatures
    @duel.player1.battlefield.select{ |b| !b.entity.find_card.is_land? }.map{ |b| b.entity }
  end

  it "playing a creature puts a creature on the battlefield" do
    tap_all_lands

    expect(battlefield_creatures).to be_empty

    expect(@duel.player1.mana_green).to eq(3)
    card = hand.first!
    game_engine.play(card)

    expect(battlefield_creatures).to eq([card.entity])
  end

  def battlefield_can_be_tapped
    available_actions[:tap].map{ |b| b.entity }
  end

  it "lands can be tapped" do
    expect(battlefield_can_be_tapped).to eq(@duel.player1.battlefield.map{ |b| b.entity })
  end

  it "after lands are tapped, lands cannot be retapped" do
    tap_all_lands
    expect(battlefield_can_be_tapped).to be_empty
  end

  it "creatures cannot be tapped" do
    tap_all_lands
    create_creatures
    expect(battlefield_can_be_tapped).to be_empty
  end

  it "we can't play a creature if it's not our turn" do
    @duel.current_player_number = 2
    @duel.save!

    expect(available_actions[:play].map { |h| h.entity }).to be_empty
  end

  it "we can't play a creature if it's not our priority, even with tapping" do
    @duel.priority_player_number = 2
    @duel.save!

    tap_all_lands

    expect(available_actions[:play].map { |h| h.entity }).to be_empty
  end

  it "we can't play a creature if it's not our turn, even with tapping" do
    @duel.current_player_number = 2
    @duel.save!

    tap_all_lands

    expect(available_actions[:play].map { |h| h.entity }).to be_empty
  end

end
