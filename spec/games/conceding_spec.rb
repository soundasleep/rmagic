require "game_helper"

RSpec.describe "Conceding games", type: :game do
  let(:duel) { create_game }
  let(:game_actions) { action_finder.game_actions(player) }

  context "the game" do
    it "is not finished yet" do
      expect(duel.is_finished?).to be(false)
    end

    it "is not in the finished phase" do
      expect(duel.finished_phase?).to be(false)
    end

    it "has nil winners" do
      expect(duel.winners).to be_nil
    end

    it "has nil losers" do
      expect(duel.losers).to be_nil
    end

    it "has nil drawers" do
      expect(duel.drawers).to be_nil
    end
  end

  context "player 1" do
    let(:player) { player1 }

    it "has a concede action" do
      expect(game_actions.map(&:key)).to include("concede")
    end
  end

  context "player 2" do
    let(:player) { player2 }

    it "has a concede action" do
      expect(game_actions.map(&:key)).to include("concede")
    end
  end

  context "when the first player concedes" do
    let(:player) { player1 }
    let(:action) { game_actions.select { |a| a.key == "concede" }.first }

    before { action.do(duel) }

    context "the game" do
      it "is finished" do
        expect(duel.is_finished?).to be(true)
      end

      it "is in the finished phase" do
        expect(duel.finished_phase?).to be(true)
      end

      it "has one winner" do
        expect(duel.winners).to eq([player2])
      end

      it "has one loser" do
        expect(duel.losers).to eq([player1])
      end

      it "has no drawers" do
        expect(duel.drawers).to be_empty
      end
    end

    context "player 1" do
      it "has no available game actions" do
        expect(game_actions).to be_empty
      end
    end

    context "player 2" do
      it "has no available game actions" do
        expect(action_finder.game_actions(player2)).to be_empty
      end
    end
  end

end
