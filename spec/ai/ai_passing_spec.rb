require "game_helper"

# This test allows us to both test that the simple AI will always pass,
# and as a way to test performance.
RSpec.describe SimpleAI, type: :ai do
  let(:duel) { create_game }

  before :each do
    duel.mulligan_phase!

    10.times { create_order_card player1.deck, Library::BasicCreature, player1.next_deck_order }
    10.times { create_order_card player2.deck, Library::BasicCreature, player2.next_deck_order }

    player2.update! is_ai: true
  end

  (0..10).each do |n|
    context "after #{n} passes" do
      before :each do
        n.times { pass_priority }
      end

      it "is our turn" do
        expect(duel.priority_player).to eq(player1)
      end
    end
  end

end
