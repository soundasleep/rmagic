require "game_helper"

RSpec.describe Library::KiorasFollower, type: :card do
  let(:duel) { create_game }

  before :each do
    create_hand_cards Library::KiorasFollower
    create_battlefield_cards Library::Metaverse1
    create_battlefield_cards Library::Island
    duel.playing_phase!
  end

  let(:creature) { player1.battlefield_creatures.first }

  let(:card) { player1.hand.select { |c| c.card.card_type.actions.include?("ability") }.first }

  let(:play_conditions) { play.conditions }
  let(:play_result) { play_conditions.evaluate_with(duel) }

  context "our creature" do
    it "exists" do
      expect(creature).to_not be_nil
    end

    context "when tapped" do
      before { creature.card.tap_card! }

      context "our card" do

        context "without a target" do
          let(:play) { PossiblePlay.new(source: card, key: "ability") }

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

        context "with a target" do
          let(:play) { PossiblePlay.new(source: card, key: "ability", target: creature) }

          context "without mana" do
            it "cannot be played" do
              expect(play_result.evaluate).to be(false), play_result.explain
            end
          end

          context "with mana" do
            before { tap_all_lands }

            it "can be played" do
              expect(play_result.evaluate).to be(false), play_result.explain
            end

            context "when played" do
              before { play.do duel }

              context "our creature" do
                it "is no longer tapped" do
                  expect(creature.card.is_tapped?).to be(false)
                end
              end
            end
          end
        end
      end
    end
  end

end
