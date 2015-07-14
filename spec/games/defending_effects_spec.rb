require "game_helper"

RSpec.describe "Defending with effects", type: :game do
  let(:duel) { create_game }
  let(:target) { duel.player1.battlefield_creatures.first }

  before :each do
    create_battlefield_cards Library::Metaverse1
    game_engine.add_effect duel.player1, Effects::TemporaryCounter, target
    duel.attacking_phase!
  end

  context "when declaring one attacker" do
    let(:attacker) { available_attackers.first }
    let(:defends) { defendable_cards(duel.player2) }

    before :each do
      game_engine.declare_attackers [attacker]
      pass_priority
    end

    it "we have defenders" do
      expect(defends).to_not be_empty
    end

    context "and declaring a defender" do
      let(:defender) { defends.first }

      before :each do
        defender.declare duel
      end

      context "after attacking" do
        before :each do
          pass_until_next_turn
        end

        it "blocks damage" do
          expect(duel.player2.life).to eq(20)
        end

        it "attacking actions include a reference to defending creatures after the attack resolves" do
          action = attacking_actions(attacker).first
          expect(action.card).to eq(defender.target.card)
        end

        it "defending actions reference the defended attacker" do
          expect(defended_actions(defender.source).first.targets.map{ |t| t.card }).to include(attacker.card)
        end

        it "destroys the defending creature" do
          expect(duel.player2.battlefield_creatures).to_not include(defender.source)
        end
      end
    end

    context "and declaring no defenders" do
      it "the player has full life" do
        expect(duel.player2.life).to eq(20)
      end

      context "after attacking" do
        before :each do
          pass_until_next_turn
        end

        it "attacks hit the player" do
          expect(duel.player2.life).to eq(20 - 2 - 1)
        end
      end
    end
  end

end
