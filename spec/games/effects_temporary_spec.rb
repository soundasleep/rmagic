require_relative "setup_game"

RSpec.describe "Temporary effects" do
  let(:duel) { create_game }
  let(:our_creature) { duel.player1.battlefield_creatures.first.card }

  before :each do
    create_creatures
  end

  it "do not exist in a new game" do
    expect(our_creature.effects).to be_empty
  end

  context "created manually" do
    before :each do
      our_creature.effects.create! effect_id: Effects::TemporaryCounter.id, order: 1
    end

    let(:effect) { our_creature.effects.first }

    it "has a valid id" do
      expect(Effects::TemporaryCounter.id).to_not be_nil
    end

    it "adds an effect to the card" do
      expect(our_creature.effects).to eq([effect])
    end

    context "modifies a creature" do
      it "with +1 power" do
        expect(our_creature.power).to eq(2 + 1)
      end

      it "with +1 toughness" do
        expect(our_creature.toughness).to eq(3 + 1)
      end
    end

    context "in the next phase" do
      before :each do
        pass_until_current_player_has_priority
      end

      it "still exist" do
        expect(our_creature.effects).to eq([effect])
      end
    end

    context "in the next players turn" do
      before :each do
        pass_until_next_player
      end

      it "no longer exist" do
        expect(our_creature.effects).to be_empty
      end
    end

    context "in our next turn" do
      before :each do
        pass_until_next_player
      end

      it "no longer exist" do
        expect(our_creature.effects).to be_empty
      end
    end
  end

end
