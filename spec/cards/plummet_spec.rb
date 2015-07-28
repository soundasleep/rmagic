require "game_helper"

RSpec.describe Library::Plummet, type: :card do
  let(:duel) { create_game }

  before :each do
    create_battlefield_cards Library::Vaporkin
    create_hand_cards Library::Plummet
  end

  let(:creature) { player1.battlefield_creatures.first }

  let(:card) { player1.hand.select { |c| c.card.card_type.actions.include?("destroy") }.first }
  let(:play_conditions) { play.conditions }
  let(:play_result) { play_conditions.evaluate_with(duel) }

  context "our creature" do
    it "exists" do
      expect(creature).to_not be_nil
    end

    it "has a card" do
      expect(creature.card).to_not be_nil
    end

    context "our instant" do

      context "without a target" do
        let(:play) { PlayAction.new(source: card, key: "destroy") }

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
        let(:play) { PlayAction.new(source: card, key: "destroy", target: creature) }

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

            context "when the stack resolves" do
              before { pass_until_stack_resolves }

              context "our creature" do
                it "is removed from the battlefield" do
                  expect(player1.battlefield_creatures).to be_empty
                end

                it "is in the graveyard" do
                  expect(player1.graveyard_creatures.map(&:card)).to include(creature.card)
                end
              end
            end
          end
        end
      end
    end
  end

end
