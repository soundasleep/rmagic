require "game_helper"

RSpec.describe "Enchantments on card toughness", type: :game do
  let(:duel) { create_game }
  let(:our_creature) { player1.battlefield_creatures.first.card }
  let(:their_creature) { player2.battlefield_creatures.first.card }

  before :each do
    create_battlefield_cards Library::BasicCreature
    duel.playing_phase!
  end

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

    it "is ours" do
      expect(our_creature.card.controller).to eq(player1)
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

    it "is theirs" do
      expect(their_creature.card.controller).to eq(player2)
    end
  end

  context "adding an enchantment" do
    before :each do
      create_battlefield_cards Library::DeadWeight
    end

    it "is ours" do
      expect(enchantment.card.controller).to eq(player1)
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

        it "has 0 power" do
          expect(our_creature.card.power).to eq(2 - 2)
        end

        it "has 1 toughness" do
          expect(our_creature.card.toughness).to eq(3 - 2)
        end

        it "has one enchantment" do
          expect(our_enchantments.length).to eq(1)
        end

        it "has our enchantment" do
          expect(our_enchantments).to eq([enchantment.card])
        end

        it "has an enchantment controlled by us" do
          expect(our_enchantments.first.card.controller).to eq(player1)
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

      it "the creature is not marked as destroyed" do
        expect(our_creature.is_destroyed?).to be(false)
      end

      context "adding another enchantment" do
        before :each do
          create_battlefield_cards Library::DeadWeight
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
              expect(our_creature.card.power).to eq(2 - 2 - 2)
            end

            it "has negative toughness" do
              expect(our_creature.card.toughness).to eq(3 - 2 - 2)
            end

            it "has two enchantments" do
              expect(our_enchantments.length).to eq(2)
            end

            it "the creature is marked as destroyed" do
              expect(our_creature.is_destroyed?).to be(true)
            end
          end

          context "when passing priority" do
            before { pass_priority }

            # the creature is not removed until the phase resolves
            it "exists" do
              expect(our_creature).to_not be_nil
            end
          end

          context "when passing to the next phase" do
            before { pass_until_next_phase }

            context "our creature" do
              it "no longer exists" do
                expect(player1.battlefield_creatures.length).to eq(0)
              end

              it "is in the graveyard" do
                expect(player1.graveyard_creatures.length).to eq(1)
              end
            end
          end
        end
      end

      context "when passing priority" do
        before { pass_priority }

        it "the creature exists" do
          expect(player1.battlefield_creatures.length).to eq(1)
        end
      end

      context "when passing to the next phase" do
        before { pass_until_next_phase }

        it "the creature exists" do
          expect(player1.battlefield_creatures.length).to eq(1)
        end
      end

      it "the creature is not marked as destroyed" do
        expect(our_creature.is_destroyed?).to be(false)
      end

      context "and applying one damage" do
        before { AddDamage.new(card: our_creature, damage: 1).call }

        it "the creature is marked as destroyed" do
          expect(our_creature.is_destroyed?).to be(true)
        end

        context "when passing priority" do
          before { pass_priority }

          # the creature is not removed until the phase resolves
          it "exists" do
            expect(player1.battlefield_creatures.length).to eq(1)
          end
        end

        context "when passing to the next phase" do
          before { pass_until_next_phase }

          context "our creature" do
            it "no longer exists" do
              expect(player1.battlefield_creatures.length).to eq(0)
            end

            it "is in the graveyard" do
              expect(player1.graveyard_creatures.length).to eq(1)
            end
          end
        end
      end
    end
  end

end
