require_relative "setup_game"

RSpec.describe "Instants add life to targets", type: :game do
  let(:duel) { create_game }
  let(:card) { first_instant_player }

  before :each do
    create_battlefield_cards Library::Metaverse1
    create_hand_cards Library::AddLifeTargets
    duel.playing_phase!
  end

  def first_instant_player
    duel.player1.hand.select{ |b| b.card.card_type.actions.include?("instant_player") }.first
  end

  def instant_player_actions(zone_card)
    actions(zone_card.card, "instant_player")
  end

  def first_instant_player_available_actions
    available_play_actions("instant_player")
  end

  context "the card" do
    it "can be found" do
      expect(card).to_not be_nil
    end

    it "has the instant_player action" do
      expect(card.card.card_type.actions).to include("instant_player")
    end

    it "has the instant_creature action" do
      expect(card.card.card_type.actions).to include("instant_creature")
    end
  end

  context "without mana" do
    it "requires mana" do
      expect(game_engine.can_do_action?(PossiblePlay.new(source: card, key: "instant_player"))).to be(false)
    end

    it "is not listed as an available action" do
      expect(first_instant_player_available_actions).to be_empty
    end
  end

  context "with mana" do
    before :each do
      tap_all_lands
    end

    context "targeting players" do

      context "can be played with mana" do
        it "and a target player" do
          expect(game_engine.can_do_action?(PossiblePlay.new(source: card, key: "instant_player", target: duel.player1))).to be(true)
        end

        it "but not with a target creature" do
          expect(game_engine.can_do_action?(PossiblePlay.new(source: card, key: "instant_player", target: duel.player1.battlefield_creatures.first))).to be(false)
        end

        it "but not without a target" do
          expect(game_engine.can_do_action?(PossiblePlay.new(source: card, key: "instant_player"))).to be(false)
        end
      end

      context "is listed as an available action" do
        it "of one type" do
          expect(first_instant_player_available_actions.to_a.uniq{ |u| u.source }.length).to eq(1)
        end

        it "of two targets" do
          expect(first_instant_player_available_actions.length).to eq(2)
        end

        it "with the correct source" do
          available_actions[:play].each do |a|
            expect(a.source).to eq(card)
          end
        end
      end

      it "all actions have source and key and target specified" do
        available_actions[:play].each do |a|
          expect(a.source).to_not be_nil
          expect(a.key).to_not be_nil
          expect(a.target).to_not be_nil
        end
      end

      it "all actions have a description" do
        available_actions[:play].each do |a|
          expect(a.description).to_not be_nil
        end
      end

      context "our player" do
        let(:our_player) { duel.player1 }

        it "exists" do
          expect(our_player).to_not be_nil
        end

        it "has 20 life" do
          expect(our_player.life).to eq(20)
        end
      end

      context "their player" do
        let(:our_player) { duel.player2 }

        it "exists" do
          expect(our_player).to_not be_nil
        end

        it "has 20 life" do
          expect(our_player.life).to eq(20)
        end
      end

      context "when activated" do
        context "on our player" do
          let(:our_player) { duel.player1 }

          before :each do
            game_engine.card_action(PossiblePlay.new(source: card, key: "instant_player", target: duel.player1))
          end

          context "our player" do
            it "exists" do
              expect(our_player).to_not be_nil
            end

            it "has 20 life" do
              expect(our_player.life).to eq(20)
            end

            it "has used mana" do
              expect(duel.player1.mana_green).to eq(2)
            end

            context "in the next phase" do
              before :each do
                pass_until_next_phase
                our_player.reload
              end

              it "the stack is empty" do
                expect(duel.stack).to be_empty
              end

              it "has 21 life" do
                # our_player.reload
                expect(our_player.life).to eq(20 + 1)
              end

              it "creates an action" do
                expect(instant_player_actions(card).map{ |card| card.card }).to eq([card.card])
              end
            end

            context "in the next players turn" do
              before :each do
                pass_until_next_player
                our_player.reload
              end

              it "still has 21 life" do
                expect(our_player.life).to eq(20 + 1)
              end

              context "in our next turn" do
                before :each do
                  pass_until_next_player
                  our_player.reload
                end

                it "still has 21 life" do
                  expect(our_player.life).to eq(20 + 1)
                end
              end
            end
          end

          context "their player" do
            let(:their_player) { duel.player2 }

            it "exists" do
              expect(their_player).to_not be_nil
            end

            it "has 20 life" do
              expect(their_player.life).to eq(20)
            end
          end
        end
      end
    end

    context "targeting creatures" do
      let(:our_creature) { duel.player1.battlefield_creatures.first }

      context "can be played with mana" do
        it "and a target creature" do
          expect(game_engine.can_do_action?(PossiblePlay.new(source: card, key: "instant_creature", target: our_creature))).to be(true)
        end

        it "but not with a target player" do
          expect(game_engine.can_do_action?(PossiblePlay.new(source: card, key: "instant_creature", target: duel.player1))).to be(false)
        end

        it "but not without a target" do
          expect(game_engine.can_do_action?(PossiblePlay.new(source: card, key: "instant_creature"))).to be(false)
        end
      end

      context "our creature" do
        it "exists" do
          expect(our_creature).to_not be_nil
        end

        it "has power 2" do
          expect(our_creature.card.power).to eq(2)
        end

        it "has toughness 3" do
          expect(our_creature.card.toughness).to eq(3)
        end
      end

      context "when activated" do
        context "on our creature" do
          before :each do
            game_engine.card_action(PossiblePlay.new(source: card, key: "instant_creature", target: our_creature))
            pass_until_next_phase
          end

          context "our creature" do
            it "exists" do
              expect(our_creature).to_not be_nil
            end

            it "has power 2" do
              expect(our_creature.card.power).to eq(2)
            end

            it "has toughness 4" do
              expect(our_creature.card.toughness).to eq(3 + 1)
            end

            it "has one effect" do
              expect(our_creature.card.effects.length).to eq(1)
            end

            context "in the next phase" do
              before :each do
                pass_until_current_player_has_priority
              end

              it "still has one effect" do
                expect(our_creature.card.effects.length).to eq(1)
              end

              it "still has toughness 4" do
                expect(our_creature.card.toughness).to eq(3 + 1)
              end
            end

            context "in the next players turn" do
              before :each do
                pass_until_next_player
              end

              it "still has one effect" do
                expect(our_creature.card.effects.length).to eq(1)
              end

              it "still has toughness 4" do
                expect(our_creature.card.toughness).to eq(3 + 1)
              end
            end

            context "in our next turn" do
              before :each do
                pass_until_next_player
              end

              it "still has one effect" do
                expect(our_creature.card.effects.length).to eq(1)
              end

              it "still has toughness 4" do
                expect(our_creature.card.toughness).to eq(3 + 1)
              end
            end
          end
        end
      end
    end

  end

end
