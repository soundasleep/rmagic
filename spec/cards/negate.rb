require "game_helper"

RSpec.describe Library::Negate, type: :card do
  let(:duel) { create_game }

  before :each do
    create_hand_cards Library::Metaverse4
    create_hand_cards Library::Negate
  end

  let(:instant) { player1.hand.select { |c| c.card.card_type.actions.include?("instant") }.first }
  let(:play_instant) { PossiblePlay.new(source: instant, key: "instant") }

  let(:card) { player1.hand.select { |c| c.card.card_type.actions.include?("counter") }.first }
  let(:play) { PossiblePlay.new(source: card, key: "counter") }
  let(:play_conditions) { play.conditions }
  let(:play_result) { play_conditions.evaluate_with(game_engine) }

  context "our card" do
    before { duel.playing_phase! }

    context "without mana" do
      it "cannot be played" do
        expect(play_result.evaluate).to be(false), play_result.explain
      end
    end

    context "with mana" do
      before { tap_all_lands }

      it "cannot be played" do
        expect(play_result.evaluate).to be(false), play_result.explain
      end
    end
  end

  context "another instant" do
    before { duel.playing_phase! }

    context "with mana" do
      before { tap_all_lands }

      context "when played" do
        before { game_engine.card_action(play_instant) }

        context "our card" do
          it "can be played" do
            expect(play_result.evaluate).to be(true), play_result.explain
          end
        end
      end
    end
  end

end
