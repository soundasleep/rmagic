require_relative "setup_game"

RSpec.describe "Creature activated abilities", type: :game do
  let(:duel) { create_game }
  let(:card) { duel.player1.hand.first }
  let(:creature) { duel.player1.battlefield.select{ |b| b.card.card_type.actions.include?("add_life") }.first }

  before :each do
    create_hand_cards Library::AddLifeActivated.id
    duel.playing_phase!
  end

  context "before playing the creature" do
    it "the battlefield is empty" do
      expect(creature).to be_nil
    end
  end

  context "without mana" do
    it "requires mana" do
      expect(game_engine.can_do_action?(PossiblePlay.new(source: card, key: "play"))).to be(false)
    end
  end

  context "with mana" do
    before :each do
      tap_all_lands
    end

    it "provides 3 green mana" do
      expect(duel.player1.mana_green).to eq(3)
    end

    it "can be played with mana" do
      expect(game_engine.can_do_action?(PossiblePlay.new(source: card, key: "play"))).to be(true)
    end

    context "when played" do
      before :each do
        game_engine.card_action(PossiblePlay.new(source: card, key: "play"))
      end

      it "adds a creature to the battlefield" do
        expect(creature).to_not be_nil
      end

      it "is turn 1" do
        expect(duel.turn).to eq(1)
      end

      context "the creature" do
        it "is played on turn 1" do
          expect(creature.card.turn_played).to eq(1)
        end

        # summoning sickness
        it "cannot be tapped" do
          expect(game_engine.can_do_action?(PossibleAbility.new(source: creature, key: "tap"))).to be(false)
        end
      end

      it "consumes mana" do
        expect(duel.player1.mana_green).to eq(1)
      end

      it "removes the creature from the hand" do
        expect(duel.player1.hand).to be_empty
      end

      context "the activated ability" do
        context "without tapping" do
          it "cannot be played" do
            expect(game_engine.can_do_action?(PossibleAbility.new(source: creature, key: "add_life"))).to be(false)
          end
        end
      end

      context "in our next turn" do
        let(:lands) { duel.player1.battlefield_lands }

        before :each do
          pass_until_next_turn
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

          it "can be tapped" do
            puts "#{creature.card.to_json}"
            expect(game_engine.can_do_action?(PossibleAbility.new(source: creature, key: "tap"))).to be(true)
          end
        end

        context "the activated ability" do
          context "without tapping" do
            it "cannot be played" do
              expect(game_engine.can_do_action?(PossibleAbility.new(source: creature, key: "add_life"))).to be(false)
            end
          end

          context "after being tapped by the player" do
            before :each do
              game_engine.card_action(PossibleAbility.new(source: creature, key: "tap"))
            end

            it "the card is tapped" do
              expect(creature.card.is_tapped?).to be(true)
            end

            it "cannot be played" do
              expect(game_engine.can_do_action?(PossibleAbility.new(source: creature, key: "add_life"))).to be(false)
            end

            context "and tapping our lands" do
              let(:player) { duel.player1 }

              before :each do
                tap_all_lands
              end

              it "can be played" do
                expect(game_engine.can_do_action?(PossibleAbility.new(source: creature, key: "add_life"))).to be(true)
              end

              it "the player still has 20 life" do
                expect(player.life).to eq(20)
              end

              context "when played" do
                before :each do
                  game_engine.card_action(PossibleAbility.new(source: creature, key: "add_life"))
                end

                it "adds life to the current player" do
                  expect(player.life).to eq(20 + 1)
                end
              end
            end
          end

          # it needs to be tapped by the current player
          context "after being tapped manually" do
            before :each do
              creature.card.tap_card!
            end

            it "the card is tapped" do
              expect(creature.card.is_tapped?).to be(true)
            end

            it "cannot be played" do
              expect(game_engine.can_do_action?(PossibleAbility.new(source: creature, key: "add_life"))).to be(false)
            end

            context "and tapping our lands" do
              let(:player) { duel.player1 }

              before :each do
                tap_all_lands
              end

              it "cannot be played" do
                expect(game_engine.can_do_action?(PossibleAbility.new(source: creature, key: "add_life"))).to be(false)
              end
            end
          end
        end
      end
    end
  end

end
