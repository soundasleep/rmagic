require "game_helper"

RSpec.describe "Turn actions", type: :game do
  let(:duel) { create_game }
  let(:logs) { duel.action_logs.where(global_action: "turn") }
  let(:log) { logs.last }

  before { duel.drawing_phase! }

  it "we have an empty log" do
    expect(logs).to be_empty
  end

  it "is turn 1" do
    expect(duel.turn).to eq(1)
  end

  context "after passing to the next phase" do
    before { pass_until_next_phase }

    it "we have an empty log" do
      expect(logs).to be_empty
    end

    it "is turn 1" do
      expect(duel.turn).to eq(1)
    end

    context "after passing to the next turn" do
      before { pass_until_next_turn }

      it "we have one log entry" do
        expect(logs.length).to eq(1)
      end

      it "is turn 2" do
        expect(duel.turn).to eq(2)
      end

      context "the last log entry" do
        it "has an action text" do
          expect(log.action_text).to_not be_empty
        end

        it "references turn 2" do
          expect(log.argument).to eq(2)
        end
      end
    end
  end

end
