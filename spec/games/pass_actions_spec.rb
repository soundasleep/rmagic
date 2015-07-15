require "game_helper"

RSpec.describe "Pass actions spec", type: :game do
  let(:duel) { create_game }

  it "player 1 has priority" do
    expect(duel.priority_player).to eq(player1)
  end

  it "player 1 has a pass action" do
    expect(game_actions(player1).any?{ |a| a.key == "pass" }).to be(true)
  end

  context "executing the pass action" do
    let(:action) { game_actions(player1).select{ |a| a.key == "pass" }.first }

    before { action.do(duel) }

    it "player 2 has priority" do
      expect(duel.priority_player).to eq(player2)
    end

    it "player 1 has no pass actions" do
      expect(game_actions(player1).any?{ |a| a.key == "pass" }).to be(false)
    end

    context "executing the pass action" do
      let(:action2) { game_actions(player2).select{ |a| a.key == "pass" }.first }

      before { action2.do(duel) }

      it "player 1 has priority" do
        expect(duel.priority_player).to eq(player1)
      end

      it "player 2 has no pass actions" do
        expect(game_actions(player2).any?{ |a| a.key == "pass" }).to be(false)
      end
    end
  end

end
