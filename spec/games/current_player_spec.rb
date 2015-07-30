require "game_helper"

RSpec.describe "Current player", type: :game do
  let(:duel) { create_game }
  let(:logs) { duel.action_logs.where(global_action: "current_player") }
  let(:log) { logs.last }

  before { duel.drawing_phase! }

  it "we have an empty log" do
    expect(logs).to be_empty
  end

  it "player 1 is the current player" do
    expect(duel.current_player).to eq(player1)
  end

  context "after passing to the next phase" do
    before { pass_until_next_phase }

    it "we have an empty log" do
      expect(logs).to be_empty
    end

    it "player 1 is the current player" do
      expect(duel.current_player).to eq(player1)
    end

    context "after passing to the next player" do
      before { pass_until_next_player }

      it "we have one log entry" do
        expect(logs.length).to eq(1)
      end

      it "player 2 is the current player" do
        expect(duel.current_player).to eq(player2)
      end

      context "the last log entry" do
        it "has an action text" do
          expect(log.action_text).to_not be_empty
        end

        it "references player 2" do
          expect(log.player).to eq(player2)
        end
      end
    end
  end

end
