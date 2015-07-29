require "game_helper"

RSpec.describe DuelPresenter, type: :presenter do
  let(:duel) { create_game }
  let(:presenter) { DuelPresenter.new(duel) }
  let(:parsed) { json.to_json }

  ["duel_json", "action_logs_json", "stack_json"].each do |method|
    context "##{method}" do
      let(:json) { presenter.send(method) }

      it "is valid json" do
        expect(parsed).to_not be_empty
      end
    end
  end

end
