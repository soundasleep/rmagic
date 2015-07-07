require "game_helper"

RSpec.describe "Defending", type: :game do
  let(:duel) { create_game }
  let(:attacker) { available_attackers.first }

  before :each do
    create_creatures

    duel.attacking_phase!

    game_engine.declare_attackers [attacker]

    game_engine.pass
  end

  it "can be declared in a phase which can declare defenders" do
    expect(duel.phase.can_declare_defenders?).to eq(true)
  end

  it "each defender can defend one attacker if only one attacks" do
    defends = action_finder.defendable_cards(duel.player2)

    expect(defends.count).to eq(2)
  end

  it "an attacker stores which player is attacking" do
    expect(duel.declared_attackers.first.player).to eq(duel.player1)
  end

  it "an attacker stores which player its attacking" do
    expect(duel.declared_attackers.first.target_player).to eq(duel.player2)
  end

  context "when finding possible defenders" do
    let(:defends) { action_finder.defendable_cards(duel.player2) }
    let(:defender) { defends.first }

    it "a declared defender creates an action" do
      expect(defending_actions(defender.source).count).to eq(0)

      game_engine.declare_defender defender
      expect(defending_actions(defender.source).count).to eq(1)
    end

    it "a defender can be declared and referenced later" do
      expect(duel.declared_defenders.count).to eq(0)
      game_engine.declare_defender defender
      expect(duel.declared_defenders.count).to eq(1)
    end

    it "declared defenders do not persist into the next turn" do
      expect(duel.declared_defenders.count).to eq(0)
      game_engine.declare_defender defender
      expect(duel.declared_defenders.count).to eq(1)

      pass_until_next_player
      expect(duel.declared_defenders.count).to eq(0)
    end

    context "and declaring a defender" do
      before :each do
        game_engine.declare_defender defender
      end

      it "the defender does not come up as another available defend option" do
        action_finder.defendable_cards(duel.player2).each do |defend|
          expect(defend.target).to_not eq(defend.source)
        end
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
      end

      it "attacking actions are created when there are defenders and the attack resolves" do
        expect(attacking_actions(attacker).count).to eq(0)

        pass_until_next_turn

        expect(attacking_actions(attacker).count).to eq(1)
      end

      it "attacking actions references the attacked defender" do
        expect(attacking_actions(attacker).count).to eq(0)

        pass_until_next_turn

        action = attacking_actions(attacker).first
        expect(action.targets.first.card).to eq(defender.source.card)
      end

      it "defending actions are created when there are defenders and the attack resolves" do
        expect(defended_actions(defender.source).count).to eq(0)

        pass_until_next_turn

        expect(defended_actions(defender.source).count).to eq(1)
      end

      it "does not destroy the defending creature" do
        expect(duel.player2.battlefield_creatures).to include(defender.source)
      end
    end
  end

  it "attacking actions are created when there are no defenders and the attack resolves" do
    expect(attacking_actions(attacker).count).to eq(0)

    pass_until_next_turn

    expect(attacking_actions(attacker).count).to eq(1)
  end

end
