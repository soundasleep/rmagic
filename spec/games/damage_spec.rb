require_relative "setup_game"

RSpec.describe "Damage" do
  before :each do
    setup

    create_creatures
  end

  def first_creature
    @duel.player1.battlefield.select{ |b| b.entity.find_card.is_creature? }.first
  end

  it "creatures start off with no damage" do
    expect(first_creature.entity.damage).to eq(0)
  end

  it "no damage causes no effects" do
    card = first_creature
    card.entity.damage! 0

    pass_until_next_turn

    expect(@duel.player1.battlefield).to include(card)
  end

  it "damage causes cards to be removed" do
    card = first_creature
    expect(@duel.player1.battlefield).to include(card)
    card.entity.damage! 100
    game_engine.move_destroyed_creatures_to_graveyard
    @duel.reload
    expect(@duel.player1.battlefield).to_not include(card)
  end

  context "too much damage" do
    before :each do
      @card = first_creature

      @card.entity.damage! 100
    end

    it "causes cards to be removed at the next turn" do
      pass_until_next_turn
      expect(@duel.player1.battlefield).to_not include(@card)
    end

    it "provides the destroyed flag" do
      expect(@card.entity.is_destroyed?).to eq(true)
    end
  end

  it "a card with little damage does not have the destroyed flag" do
    card = first_creature
    card.entity.damage! 0
    expect(card.entity.is_destroyed?).to eq(false)
  end

  it "a card with one damage does not have the destroyed flag" do
    card = first_creature
    card.entity.damage! 1
    expect(card.entity.is_destroyed?).to eq(false)
  end

  it "a destroyed creature is moved into the graveyard" do
    card = first_creature
    expect(@duel.player1.graveyard.map { |b| b.entity }).to_not include(card.entity)

    card.entity.damage! 100
    pass_until_next_turn

    expect(@duel.player1.graveyard.map { |b| b.entity }).to include(card.entity)
  end

  it "actions are created when creatures are moved to the graveyard" do
    card = first_creature

    expect(graveyard_actions(card.entity)).to be_empty

    card.entity.damage! 100
    pass_until_next_turn

    expect(graveyard_actions(card.entity).count).to equal(1)
  end

  context "temporary damage" do
    before :each do
      @card = first_creature
      expect(@card.entity.find_card.toughness).to_not equal(1)
      @card.entity.damage! 1
    end

    it "does not cause a card to be removed" do
      pass_until_next_turn

      expect(@duel.player1.battlefield).to include(@card)
    end

    it "is not removed until the next players turn" do
      game_engine.pass
      expect(@card.entity.damage).to eq(1)

      @card.entity.reload
      expect(@card.entity.damage).to eq(1)
    end

    it "is removed at the start of the next players turn" do
      pass_until_next_turn

      @card.entity.reload
      expect(@card.entity.damage).to eq(0)
    end
  end

end
