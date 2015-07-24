require "game_helper"

RSpec.describe "Enchantments on card power", type: :game do
  let(:duel) { create_game }
  let(:our_creature) { player1.battlefield_creatures.first.card }
  let(:their_creature) { player2.battlefield_creatures.first.card }

  before { create_battlefield_cards Library::BasicCreature }

  let(:our_enchantments) { our_creature.enchantments }
  let(:their_enchantments) { their_creature.enchantments }
  let(:enchantment) { player1.battlefield.select{ |c| c.card.card_type.is_enchantment? }.first }

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

    context "after passing priority" do
      before { pass_priority }

      it "is removed immediately" do
        expect(enchantment).to be_nil
      end
    end

    context "after passing to the next turn" do
      before { pass_until_next_turn }

      it "is removed immediately" do
        expect(enchantment).to be_nil
      end
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

        it "has our enchantment" do
          expect(our_enchantments).to eq([enchantment.card])
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

      context "when the creature is removed" do
        before :each do
          MoveCardOntoGraveyard.new(duel: duel, player: player1, card: our_creature.card).call
        end

        context "the creature" do
          it "no longer exists" do
            expect(player1.battlefield_creatures).to be_empty
          end
        end

        context "the enchantment" do
          it "no longer exists" do
            # the enchantment should be removed as soon as the attached card is removed
            expect(enchantment).to be_nil
          end

          context "after passing priority" do
            before { pass_priority }

            it "no longer exists" do
              expect(enchantment).to be_nil
            end
          end
        end
      end

      context "the enchantment" do
        context "after passing priority" do
          before { pass_priority }

          it "exists" do
            expect(enchantment).to_not be_nil
          end
        end

        context "after passing to the next turn" do
          before { pass_until_next_turn }

          it "exists" do
            expect(enchantment).to_not be_nil
          end
        end
      end
    end
  end

end
