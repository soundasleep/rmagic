require "game_helper"

RSpec.describe "Card visibility", type: :games do
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

  context "in the playing phase" do
    before { duel.playing_phase! }

    it "we have 1 card in hand" do
      expect(player1.hand.length).to eq(1)
    end

    context "our hand card" do
      let(:card) { player1.hand.first }

      it "is visible to player 1" do
        expect(card.is_visible_to?(player1)).to be(true)
      end

      it "is not visible to player 2" do
        expect(card.is_visible_to?(player2)).to be(false)
      end
    end

    context "one of our battlefield cards" do
      let(:card) { player1.battlefield.first }

      it "is visible to player 1" do
        expect(card.is_visible_to?(player1)).to be(true)
      end

      it "is visible to player 2" do
        expect(card.is_visible_to?(player2)).to be(true)
      end
    end

    context "the top of our deck" do
      let(:card) { player1.deck.first }

      it "is not visible to player 1" do
        expect(card.is_visible_to?(player1)).to be(false)
      end

      it "is not visible to player 2" do
        expect(card.is_visible_to?(player2)).to be(false)
      end
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

        context "our card in the stack" do
          let(:card) { duel.stack.first }

          it "is visible to player 1" do
            expect(card.is_visible_to?(player1)).to be(true)
          end

          it "is visible to player 2" do
            expect(card.is_visible_to?(player2)).to be(true)
          end
        end

        context "when the stack resolves" do
          before { pass_until_stack_resolves }

          it "we have 3 cards in hand" do
            expect(player1.hand.length).to eq(3)
          end

          context "our next hand card" do
            let(:card) { player1.hand.first }

            it "is visible to player 1" do
              expect(card.is_visible_to?(player1)).to be(true)
            end

            it "is not visible to player 2" do
              expect(card.is_visible_to?(player2)).to be(false)
            end
          end

          it "the stack is empty" do
            expect(duel.stack).to be_empty
          end

          context "our last graveyard card" do
            let(:card) { player1.graveyard.last }

            it "is visible to player 1" do
              expect(card.is_visible_to?(player1)).to be(true)
            end

            it "is visible to player 2" do
              expect(card.is_visible_to?(player2)).to be(true)
            end
          end
        end
      end
    end
  end

end
