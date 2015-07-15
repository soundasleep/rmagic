require "game_helper"

RSpec.describe Library::PinToTheEarth, type: :card do
  let(:duel) { create_game }

  before :each do
    create_hand_cards Library::PinToTheEarth
    create_battlefield_cards Library::Metaverse1
    create_battlefield_cards Library::Island
    duel.playing_phase!
  end

  let(:creature) { player1.battlefield_creatures.first }

  let(:card) { player1.hand.select { |c| c.card.card_type.actions.include?("enchant") }.first }

  let(:play_conditions) { play.conditions }
  let(:play_result) { play_conditions.evaluate_with(duel) }

  context "our creature" do
    it "exists" do
      expect(creature).to_not be_nil
    end

    it "has 2 power" do
      expect(creature.card.power).to eq(2)
    end

    it "has 3 toughness" do
      expect(creature.card.toughness).to eq(3)
    end

    context "our card" do

      context "without a target" do
        let(:play) { PlayAction.new(source: card, key: "enchant") }

        context "with mana" do
          before { tap_all_lands }

          it "cannot be played" do
            expect(play_result.evaluate).to be(false), play_result.explain
          end
        end
      end

      context "with a target" do
        let(:play) { PlayAction.new(source: card, key: "enchant", target: creature) }

        context "with mana" do
          before { tap_all_lands }

          it "can be played" do
            expect(play_result.evaluate).to be(true), play_result.explain
          end

          context "when played" do
            before { play.do duel }

            # has not resolved yet
            context "our creature" do
              it "has 2 power" do
                expect(creature.card.power).to eq(2)
              end

              it "has 3 toughness" do
                expect(creature.card.toughness).to eq(3)
              end

              it "has no enchantments" do
                expect(creature.card.enchantments.length).to eq(0)
              end
            end

            context "our enchantment" do
              it "is not yet on the battlefield" do
                expect(player1.battlefield.map { |c| c.card }).to_not include(card.card)
              end
            end

            context "when we let the enchantment resolve" do
              before { pass_until_stack_resolves }

              context "our creature" do
                it "has negative power" do
                  expect(creature.card.power).to eq(2 - 6)
                end

                it "has 3 toughness" do
                  expect(creature.card.toughness).to eq(3)
                end

                it "has an enchantment" do
                  expect(creature.card.enchantments.length).to eq(1)
                end
              end

              context "our enchantment" do
                it "is on the battlefield" do
                  expect(player1.battlefield.map { |c| c.card }).to include(card.card)
                end
              end
            end
          end
        end
      end
    end
  end

end
