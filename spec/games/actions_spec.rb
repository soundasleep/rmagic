require_relative "setup_game"

RSpec.describe "Actions", type: :game do
  let(:duel) { create_game }
  let(:card) { duel.player1.hand.first }
  let(:creature) { duel.player1.battlefield.select{ |b| b.card.card_type.actions.include?("add_life") }.first }

  before :each do
    create_hand_cards Library::AddLifeActivated
    duel.playing_phase!
  end

  let(:play) { PossiblePlay.new(source: card, key: "play") }

  context "with mana" do
    before :each do
      tap_all_lands
    end

    it "can be played with mana" do
      expect(game_engine.can_do_action?(play)).to be(true)
    end

    context "the play action" do
      let(:actions) { play.actions }

      it "has a name" do
        expect(actions.name).to_not be_nil
      end

      context "when executing" do
        let(:result) { actions.execute_with(game_engine) }

        it "executes to true" do
          expect(result.execute).to be(true), result.explain
        end

        it "returns a explanation of why" do
          expect(result.explain).to_not be_empty
        end
      end
    end

    context "when played" do
      before { game_engine.card_action(play) }

      context "in our next turn" do
        before :each do
          pass_until_next_turn
          duel.playing_phase!
        end

        context "the activated ability" do
          let (:ability) { PossibleAbility.new(source: creature, key: "add_life") }

          context "with mana" do
            let(:player) { duel.player1 }

            before { tap_all_lands }

            context "the ability action" do
              let(:actions) { ability.actions }

              it "has a name" do
                expect(actions.name).to_not be_nil
              end

              context "when executing" do
                let(:result) { actions.execute_with(game_engine) }

                it "executes to true" do
                  expect(result.execute).to be(true), result.explain
                end

                it "returns a explanation of why" do
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
