require "game_helper"

RSpec.describe "Conceding games", type: :game do
  let(:duel) { create_game }
  let(:game_actions) { action_finder.game_actions(player) }
  let(:concede_logs) { duel.action_logs.where(global_action: "concede") }
  let(:won_logs) { duel.action_logs.where(global_action: "won") }

  context "the duel" do
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

    it "has no concede logs" do
      expect(concede_logs).to be_empty
    end

    it "has no won logs" do
      expect(won_logs).to be_empty
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

    context "the duel" do
      it "is finished" do
        expect(duel.is_finished?).to be(true)
      end

      it "is in the finished phase" do
        expect(duel.finished_phase?).to be(true)
      end

      it "has one concede logs" do
        expect(concede_logs.length).to eq(1)
      end

      it "has one concede logs for player 1" do
        expect(concede_logs.first.player).to eq(player1)
      end

      it "has one won logs" do
        expect(won_logs.length).to eq(1)
      end

      it "has one won log for player 2" do
        expect(won_logs.first.player).to eq(player2)
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

      context "player 1" do
        it "has lost" do
          expect(player1).to be_lost
        end

        it "has not won" do
          expect(player1).to_not be_won
        end

        it "has not drawn" do
          expect(player1).to_not be_drawn
        end
      end

      context "player 2" do
        it "has won" do
          expect(player2).to be_won
        end

        it "has not lost" do
          expect(player2).to_not be_lost
        end

        it "has not drawn" do
          expect(player2).to_not be_drawn
        end
      end
    end

    context "player 1" do
      let(:refreshed_game_actions) { action_finder.game_actions(player) }

      it "has no available game actions" do
        expect(refreshed_game_actions).to be_empty
      end
    end

    context "player 2" do
      let(:refreshed_game_actions) { action_finder.game_actions(player2) }

      it "has no available game actions" do
        expect(refreshed_game_actions).to be_empty
      end
    end
  end

end
