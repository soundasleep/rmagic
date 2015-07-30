require "game_helper"

RSpec.describe PlayerPresenter, type: :presenter do
  let(:duel) { create_game }
  let(:presenter) { PlayerPresenter.new(player1) }
  let(:parsed) { json.to_json }

  ["player_json", "deck_json", "battlefield_json", "hand_json", "graveyard_json", "actions_json"].each do |method|
    context "##{method}" do
      let(:json) { presenter.send(method) }

      it "is valid json" do
        expect(parsed).to_not be_empty
      end
    end
  end

  let(:context) { player1 }

  ["deck_json", "battlefield_json", "hand_json", "graveyard_json", "actions_json"].each do |method|
    context "##{method}(context)" do
      let(:json) { presenter.send(method, context) }

      it "is valid json" do
        expect(parsed).to_not be_empty
      end
    end
  end

end
