require "game_helper"

RSpec.describe TextualActions, type: :action do
  let(:duel) { nil }
  let(:stack) { nil }

  texts = [
    "move this card onto the graveyard",
    "add 1 life to the owner of this card",
    "add 1 life to the target player",
  ]

  texts.each do |text|
    context text do
      let(:action) { TextualActions.new(text) }

      it "can be described" do
        expect(action.describe).to eq(text)
      end
    end
  end

end
