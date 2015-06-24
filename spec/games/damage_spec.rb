require_relative "setup_game"

RSpec.describe "Damage" do
  let(:duel) { create_game }

  before :each do
    create_creatures
  end

  def first_creature
    duel.player1.battlefield.select{ |b| b.card.card_type.is_creature? }.first
  end

  it "creatures start off with no damage" do
    expect(first_creature.card.damage).to eq(0)
  end

  it "no damage causes no effects" do
    card = first_creature
    card.card.damage! 0

    pass_until_next_turn

    expect(duel.player1.battlefield).to include(card)
  end

  it "damage causes cards to be removed" do
    card = first_creature
    expect(duel.player1.battlefield).to include(card)
    card.card.damage! 100
    game_engine.move_destroyed_creatures_to_graveyard
    duel.reload
    expect(duel.player1.battlefield).to_not include(card)
  end

  let(:creature) { first_creature }

  context "too much damage" do
    before :each do
      creature.card.damage! 100
    end

    it "causes cards to be removed at the next turn" do
      pass_until_next_turn
      expect(duel.player1.battlefield).to_not include(creature)
    end

    it "provides the destroyed flag" do
      expect(creature.card.is_destroyed?).to eq(true)
    end
  end

  it "a card with little damage does not have the destroyed flag" do
    card = first_creature
    card.card.damage! 0
    expect(card.card.is_destroyed?).to eq(false)
  end

  it "a card with one damage does not have the destroyed flag" do
    card = first_creature
    card.card.damage! 1
    expect(card.card.is_destroyed?).to eq(false)
  end

  it "a destroyed creature is moved into the graveyard" do
    card = first_creature
    expect(duel.player1.graveyard.map { |b| b.card }).to_not include(card.card)

    card.card.damage! 100
    pass_until_next_turn

    expect(duel.player1.graveyard.map { |b| b.card }).to include(card.card)
  end

  it "actions are created when creatures are moved to the graveyard" do
    card = first_creature

    expect(graveyard_actions(card.card)).to be_empty

    card.card.damage! 100
    pass_until_next_turn

    expect(graveyard_actions(card.card).count).to eq(1)
  end

  context "temporary damage" do
    before :each do
      expect(creature.card.card_type.toughness).to_not eq(1)
      creature.card.damage! 1
    end

    it "does not cause a card to be removed" do
      pass_until_next_turn

      expect(duel.player1.battlefield).to include(creature)
    end

    it "is not removed until the next players turn" do
      game_engine.pass
      expect(creature.card.damage).to eq(1)

      creature.card.reload
      expect(creature.card.damage).to eq(1)
    end

    it "is removed at the start of the next players turn" do
      pass_until_next_turn

      creature.card.reload
      expect(creature.card.damage).to eq(0)
    end
  end

end
