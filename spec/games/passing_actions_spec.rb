require "game_helper"

RSpec.describe "Passing actions", type: :game do
  let(:duel) { create_game }
  let(:logs) { duel.action_logs.where(global_action: "enter_phase") }
  let(:log) { logs.last }

  before { duel.drawing_phase! }

  it "we have an empty log" do
    expect(logs).to be_empty
  end

  it "we are in drawing phase" do
    expect(duel).to be_drawing_phase
  end

  context "after passing to the next phase" do
    before { pass_until_next_phase }

    it "we are in playing phase" do
      expect(duel).to be_playing_phase
    end

    it "we have one log entry" do
      expect(logs.length).to eq(1)
    end

    context "the last log entry" do
      it "is to playing phase" do
        expect(log.phase.to_sym).to eq(:playing_phase)
      end

      it "has an action text" do
        expect(log.action_text).to_not be_empty
      end
    end

    context "after passing to the next phase" do
      before { pass_until_next_phase }

      it "we are in attacking phase" do
        expect(duel).to be_attacking_phase
      end

      it "we have two log entries" do
        expect(logs.length).to eq(2)
      end

      context "the last log entry" do
        it "is to attacking phase" do
          expect(log.phase.to_sym).to eq(:attacking_phase)
        end

        it "has an action text" do
          expect(log.action_text).to_not be_empty
        end
      end
    end
  end

end
