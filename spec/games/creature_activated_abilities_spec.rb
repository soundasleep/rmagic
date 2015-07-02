require_relative "setup_game"

RSpec.describe "Creature activated abilities", type: :game do
  let(:duel) { create_game }
  let(:card) { duel.player1.hand.first }
  let(:creature) { duel.player1.battlefield.select{ |b| b.card.card_type.actions.include?("add_life") }.first }

  before :each do
    create_hand_cards Library::AddLifeActivated.id
    duel.playing_phase!
  end

  it_behaves_like "playable creature from hand"

  context "with mana" do
    before :each do
      tap_all_lands
    end

    context "when played" do
      before :each do
        game_engine.card_action(PossiblePlay.new(source: card, key: "play"))
      end

      let(:ability) { PossibleAbility.new(source: creature, key: "add_life") }

      context "the activated ability" do
        it "cannot be played" do
          expect(game_engine.can_do_action?(ability)).to be(false)
        end
      end

      context "in our next turn" do
        let(:lands) { duel.player1.battlefield_lands }

        before :each do
          pass_until_next_turn
          duel.playing_phase!
        end

        it "all the lands are untapped" do
          lands.each do |land|
            expect(land.card.is_tapped?).to be(false)
          end
        end

        it "the turn number increases" do
          expect(duel.turn).to eq(2)
        end

        context "the creature" do
          it "is a valid card type" do
            expect(creature.card.card_type).to_not be(false)
          end

          it "is not tapped" do
            expect(creature.card.is_tapped?).to be(false)
          end

          it "can be tapped manually" do
            expect(creature.card.can_tap?).to be(true)
          end
        end

        context "the activated ability" do
          it "cannot be played" do
            expect(game_engine.can_do_action?(ability)).to be(false)
          end

          context "after being tapped manually" do
            before :each do
              creature.card.tap_card!
            end

            it "cannot be played" do
              expect(game_engine.can_do_action?(ability)).to be(false)
            end
          end

          context "without mana" do
            it "cannot be activated" do
              expect(game_engine.can_do_action?(ability)).to be(false)
            end
          end

          context "with mana" do
            let(:player) { duel.player1 }

            before :each do
              tap_all_lands
            end

            it "can be activated" do
              expect(game_engine.can_do_action?(ability)).to be(true)
            end

            it "the player still has 20 life" do
              expect(player.life).to eq(20)
            end

            context "when activated" do
              before :each do
                game_engine.card_action(ability)
              end

              it "the card is tapped" do
                expect(creature.card.is_tapped?).to be(true)
              end

              it "the card cannot be tapped" do
                expect(creature.card.can_tap?).to be(false)
              end

              it "adds life to the current player" do
                expect(player.life).to eq(20 + 1)
              end
            end
          end
        end
      end
    end
  end

end
