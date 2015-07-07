require_relative "setup_game"

RSpec.describe "Conditions", type: :game do
  let(:duel) { create_game }
  let(:card) { duel.player1.hand.first }
  let(:creature) { duel.player1.battlefield.select{ |b| b.card.card_type.actions.include?("add_life") }.first }

  before :each do
    create_hand_cards Library::AddLifeActivated
  end

  let(:play) { PossiblePlay.new(source: card, key: "play") }

  context "in the first phase" do
    it "cannot be played" do
      expect(game_engine.can_do_action?(play)).to be(false)
    end

    context "the play condition" do
      let(:conditions) { play.conditions }

      it "has a name" do
        expect(conditions.name).to_not be_nil
      end

      context "when evaluating" do
        let(:result) { conditions.evaluate_with(game_engine) }

        it "evaluates to false" do
          expect(result.evaluate).to be(false), result.explain
        end

        it "returns a description of why" do
          expect(result.explain).to_not be_empty
        end
      end
    end
  end

  context "in playing phase" do
    before { duel.playing_phase! }
    context "with mana" do
      before :each do
        tap_all_lands
      end

      it "can be played with mana" do
        expect(game_engine.can_do_action?(play)).to be(true)
      end

      context "the play condition" do
        let(:conditions) { play.conditions }

        it "has a name" do
          expect(conditions.name).to_not be_nil
        end

        context "when evaluating" do
          let(:result) { conditions.evaluate_with(game_engine) }

          it "evaluates to true" do
            expect(result.evaluate).to be(true), result.explain
          end

          it "returns a description of why" do
            expect(result.explain).to_not be_empty
          end
        end
      end

      context "when played" do
        before { game_engine.card_action(play) }

        context "after passing to the next phase" do
          before { pass_until_next_phase }

          let (:ability) { PossibleAbility.new(source: creature, key: "add_life") }

          context "the activated ability" do
            it "cannot be played" do
              expect(game_engine.can_do_action?(ability)).to be(false)
            end

            context "the ability condition" do
              let(:conditions) { ability.conditions }

              it "has a name" do
                expect(conditions.name).to_not be_nil
              end

              context "when evaluating" do
                let(:result) { conditions.evaluate_with(game_engine) }

                it "evaluates to false" do
                  expect(result.evaluate).to be(false), result.explain
                end

                it "returns a description of why" do
                  expect(result.explain).to_not be_empty
                end
              end
            end
          end
        end

        context "in our next turn" do
          let(:lands) { duel.player1.battlefield_lands }

          before :each do
            pass_until_next_turn
            duel.playing_phase!
          end

          context "the activated ability" do
            let (:ability) { PossibleAbility.new(source: creature, key: "add_life") }

            context "with mana" do
              let(:player) { duel.player1 }

              before { tap_all_lands }

              context "the ability condition" do
                let(:conditions) { ability.conditions }

                it "has a name" do
                  expect(conditions.name).to_not be_nil
                end

                context "when evaluating" do
                  let(:result) { conditions.evaluate_with(game_engine) }

                  it "evaluates to true" do
                    expect(result.evaluate).to be(true), result.explain
                  end

                  it "returns a description of why" do
                    expect(result.explain).to_not be_empty
                  end
                end
              end
            end
          end
        end
      end
    end
  end

end
