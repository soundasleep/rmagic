require_relative "game_test"

RSpec.describe "Passing" do
  before :each do
    setup

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

  it "we can tap forests to get green mana" do
    expect(@duel.player1.mana_green).to eq(0)
    expect(untapped_land.player).to eq(@duel.player1)

    game_engine.card_action(untapped_land, "tap")
    expect(@duel.player1.mana_green).to eq(1)

    game_engine.card_action(untapped_land, "tap")
    expect(@duel.player1.mana_green).to eq(2)
  end

  it "we can tap cards" do
    card = untapped_land
    expect(card.entity.is_tapped?).to eq(false)
    game_engine.card_action(card, "tap")
    card.reload
    card.entity.reload
    expect(card.entity.is_tapped?).to eq(true)

    # we have another untapped land
    card = untapped_land
    expect(card.entity.is_tapped?).to eq(false)
  end

  it "we can tap cards directly" do
    card = untapped_land
    expect(card.entity.is_tapped?).to eq(false)
    card.entity.tap_card!
    expect(card.entity.is_tapped?).to eq(true)
  end

  it "we can tap cards directly through entity" do
    entity = untapped_land.entity
    expect(entity.is_tapped?).to eq(false)
    entity.tap_card!
    expect(entity.is_tapped?).to eq(true)
  end

  it "tapping does not modify duel phase" do
    game_engine.card_action(untapped_land, "tap")
    expect(@duel.phase_number).to eq(Duel.playing_phase)
  end

  it "tapping creates an action" do
    expect(Action.where(duel: @duel)).to be_empty

    card = untapped_land
    game_engine.card_action(card, "tap")

    action = Action.where(duel: @duel).first!
    expect(action.entity).to eq(card.entity)
  end

  it "tapped lands untap in the next turn" do
    tap_all_lands
    expect(untapped_lands).to be_empty

    pass_until_next_turn
    expect(untapped_lands).to_not be_empty
  end

  it "tapped lands do not untap in the next players current turn" do
    tap_all_lands
    expect(untapped_lands).to be_empty
    turn = @duel.turn

    pass_until_next_player
    expect(untapped_lands).to be_empty
    expect(@duel.turn).to eq(turn)

    pass_until_next_player
    expect(untapped_lands).to_not be_empty
    expect(@duel.turn).to_not eq(turn)
  end

  it "tapped mana disappears after a pass" do
    expect(@duel.player1.mana_green).to eq(0)

    tap_all_lands
    expect(@duel.player1.mana_green).to eq(3)

    game_engine.pass

    expect(@duel.player1.mana_green).to eq(0)
  end

end
