require "game_helper"

RSpec.describe Library::JacesIngenuity, type: :card do
  let(:duel) { create_game }

  before :each do
    create_hand_cards Library::JacesIngenuity
    4.times { create_battlefield_cards Library::Island }
    3.times { create_deck_cards Library::Forest }
  end

  let(:instant) { player1.hand.select { |c| c.card.card_type.actions.include?("instant") }.first }
  let(:play_instant) { PlayAction.new(source: instant, key: "instant") }
  let(:play_conditions) { play_instant.conditions }
  let(:play_result) { play_conditions.evaluate_with(duel) }

  context "our card" do
    before { duel.playing_phase! }

    it "we have 1 card in hand" do
      expect(player1.hand.length).to eq(1)
    end

    it "the stack is empty" do
      expect(duel.stack).to be_empty
    end

    context "with mana" do
      before { tap_all_lands }

      it "can be played" do
        expect(play_result.evaluate).to be(true), play_result.explain
      end

      context "when played" do
        before { play_instant.do(duel) }

        it "we have 0 cards in hand" do
          expect(player1.hand).to be_empty
        end

        it "goes on the stack" do
          expect(duel.stack).to_not be_empty
        end

        context "when the stack resolves" do
          before { pass_until_stack_resolves }

          it "we have 3 cards in hand" do
            expect(player1.hand.length).to eq(3)
          end

          it "the stack is empty" do
            expect(duel.stack).to be_empty
          end
        end
      end
    end
  end

end
