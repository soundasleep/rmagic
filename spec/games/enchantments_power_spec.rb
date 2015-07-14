require "game_helper"

RSpec.describe "Enchantments on card power", type: :game do
  let(:duel) { create_game }
  let(:our_creature) { player1.battlefield_creatures.first.card }
  let(:their_creature) { player2.battlefield_creatures.first.card }

  before { create_creatures }

  let(:our_enchantments) { our_creature.enchantments }
  let(:their_enchantments) { their_creature.enchantments }

  context "our creature" do
    it "exists" do
      expect(our_creature).to_not be_nil
    end

    it "has 2 power" do
      expect(our_creature.card.power).to eq(2)
    end

    it "has 3 toughness" do
      expect(our_creature.card.toughness).to eq(3)
    end

    it "has no enchantments" do
      expect(our_enchantments).to be_empty
    end
  end

  context "their creature" do
    it "exists" do
      expect(their_creature).to_not be_nil
    end

    it "has 2 power" do
      expect(their_creature.card.power).to eq(2)
    end

    it "has 3 toughness" do
      expect(their_creature.card.toughness).to eq(3)
    end

    it "has no enchantments" do
      expect(their_enchantments).to be_empty
    end
  end

  context "adding an enchantment" do
    before :each do
      create_battlefield_cards Library::PinToTheEarth
    end

    it "is removed immediately after passing" do
      fail "not implemented"
    end

    context "and attaching it to our creature" do
      before :each do
        player1.battlefield.select { |c| c.card.card_type.is_enchantment? }.each do |card|
          AttachCardToTarget.new(duel: duel, player: player1, card: card, target: our_creature).call
        end
      end

      context "our creature" do
        it "exists" do
          expect(our_creature).to_not be_nil
        end

        it "has negative power" do
          expect(our_creature.card.power).to eq(2 - 6)
        end

        it "has 3 toughness" do
          expect(our_creature.card.toughness).to eq(3)
        end

        it "has one enchantment" do
          expect(our_enchantments.length).to eq(1)
        end

        it "persists in the next turn" do
          fail "not implemented"
        end

        it "can still attack" do
          fail "not implemented"
        end

        it "causes 0 damage when attacking" do
          fail "not implemented"
        end
      end

      context "their creature" do
        it "exists" do
          expect(their_creature).to_not be_nil
        end

        it "has 2 power" do
          expect(their_creature.card.power).to eq(2)
        end

        it "has 3 toughness" do
          expect(their_creature.card.toughness).to eq(3)
        end

        it "has no enchantments" do
          expect(their_enchantments).to be_empty
        end
      end

      it "is not removed in the next turn" do
        fail "not implemented"
      end

      it "is removed from the battlefield when the attached card is removed" do
        fail "not implemented"
      end
    end
  end

  it "tests for enchantments on toughness" do
    fail "not implemented"
  end

end
