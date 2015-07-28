require "game_helper"

RSpec.describe "Attacking with enchantments", type: :game do
  let(:duel) { create_game }
  let(:our_creature) { player1.battlefield_creatures.first.card }
  let(:their_creature) { player2.battlefield_creatures.first.card }

  before :each do
    create_battlefield_cards Library::BasicCreature
    create_battlefield_cards Library::PinToTheEarth
    player1.battlefield.select { |c| c.card.card_type.is_enchantment? }.each do |card|
      AttachCardToTarget.new(duel: duel, player: player1, card: card, target: our_creature).call
    end
  end

  let(:our_enchantments) { our_creature.enchantments }
  let(:their_enchantments) { their_creature.enchantments }
  let(:enchantment) { player1.battlefield.select{ |c| c.card.card_type.is_enchantment? }.first }

  context "our creature" do
    it "exists" do
      expect(our_creature).to_not be_nil
    end

    it "has negative power" do
      expect(our_creature.card.power).to eq(2 - 6)
    end
  end

  context "before attacking" do
    before { duel.attacking_phase! }

    it "we can declare attackers" do
      expect(available_attackers).to_not be_empty
    end

    it "we can define our creature as an attacker" do
      expect(available_attackers.map(&:card)).to eq([our_creature])
    end

    context "after declaring attackers" do
      before :each do
        declare_attackers available_attackers
        pass_priority
      end

      context "after declaring no defenders" do
        context "passing priority" do
          before { pass_priority }

          context "player 2" do
            it "has full health" do
              expect(player2.life).to eq(20)
            end
          end
        end

        context "passing to the next turn" do
          before { pass_until_next_player }

          context "player 2" do
            it "has full health" do
              expect(player2.life).to eq(20)
            end
          end
        end
      end

      context "the target creature" do
        it "has no damage" do
          expect(their_creature.damage).to eq(0)
        end
      end

      context "after declaring a single defender" do
        let(:defends) { action_finder.defendable_cards(duel.player2) }
        let(:defender) { defends.first }

        before { defender.declare duel }

        context "passing priority" do
          before { pass_priority }

          context "the target creature" do
            it "has no damage" do
              expect(their_creature.damage).to eq(0)
            end
          end
        end

        context "passing to the next turn" do
          before { pass_until_next_player }

          context "the target creature" do
            it "has no damage" do
              expect(their_creature.damage).to eq(0)
            end
          end
        end
      end
    end
  end

end
