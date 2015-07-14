require "game_helper"

RSpec.describe "Instants effects", type: :game do
  let(:duel) { create_game }
  let(:card) { first_counter }

  before :each do
    create_battlefield_cards Library::Metaverse1
    create_hand_cards Library::InstantCounter
    duel.playing_phase!
  end

  def first_counter
    duel.player1.hand.select{ |b| b.card.card_type.actions.include?("counter") }.first
  end

  def counter_actions(zone_card)
    actions(zone_card.card, "counter")
  end

  def first_counter_available_actions
    available_play_actions("counter")
  end

  it "can be found" do
    expect(first_counter).to_not be_nil
  end

  context "without mana" do
    let(:play) { PossiblePlay.new(source: card, key: "counter") }

    it "requires mana" do
      expect(play.can_do?(duel)).to be(false)
    end

    it "is not listed as an available action" do
      expect(first_counter_available_actions).to be_empty
    end
  end

  context "with mana" do
    before :each do
      tap_all_lands
    end

    context "with a target" do
      let(:play) { PossiblePlay.new(source: card, key: "counter", target: duel.player1.battlefield_creatures.first) }

      it "can be played" do
        expect(play.can_do?(duel)).to be(true)
      end
    end

    context "without a target" do
      let(:play) { PossiblePlay.new(source: card, key: "counter") }

      it "can not be played" do
        expect(play.can_do?(duel)).to be(false)
      end
    end

    context "is listed as an available action" do
      it "of one type" do
        expect(first_counter_available_actions.to_a.uniq{ |u| u.source }.length).to eq(1)
      end

      it "of two targets" do
        expect(first_counter_available_actions.length).to eq(2)
      end

      it "with the correct source and key" do
        playable_cards(duel.player1).each do |a|
          expect(a.source).to eq(card)
          expect(a.key).to eq("counter")
        end
      end
    end

    it "all actions have source and key and target specified" do
      playable_cards(duel.player1).each do |a|
        expect(a.source).to_not be_nil
        expect(a.key).to_not be_nil
        expect(a.target).to_not be_nil
      end
    end

    it "all actions have a description" do
      playable_cards(duel.player1).each do |a|
        expect(a.description).to_not be_nil
      end
    end

    context "our creature" do
      let(:our_creature) { duel.player1.battlefield_creatures.first }

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

    context "their creature" do
      let(:our_creature) { duel.player2.battlefield_creatures.first }

      it "exists" do
        expect(our_creature).to_not be_nil
      end

      it "has power 2" do
        expect(our_creature.card.power).to eq(2)
      end

      it "has toughness 3" do
        expect(our_creature.card.toughness).to eq(3)
      end

      it "has no effects" do
        expect(our_creature.card.effects).to be_empty
      end
    end

    context "when activated" do
      before :each do
        expect(duel.player1.battlefield_creatures.length).to eq(1)
        expect(duel.player2.battlefield_creatures.length).to eq(1)
      end

      context "on our creature" do
        before :each do
          game_engine.card_action(PossiblePlay.new(source: card, key: "counter", target: duel.player1.battlefield_creatures.first))
          pass_until_next_phase
        end

        context "our creature" do
          let(:our_creature) { duel.player1.battlefield_creatures.first }

          it "exists" do
            expect(our_creature).to_not be_nil
          end

          it "has power 3" do
            expect(our_creature.card.power).to eq(2 + 1)
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
          end

          context "in the next players turn" do
            before :each do
              pass_until_next_player
            end

            it "no longer has any effects" do
              expect(our_creature.card.effects).to be_empty
            end
          end

          context "in our next turn" do
            before :each do
              pass_until_next_player
            end

            it "no longer has any effects" do
              expect(our_creature.card.effects).to be_empty
            end
          end
        end

        context "their creature" do
          let(:our_creature) { duel.player2.battlefield_creatures.first }

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

        it "creates an action" do
          expect(counter_actions(card).map{ |card| card.card }).to eq([card.card])
        end
      end

      context "on their creature" do
        before :each do
          game_engine.card_action(PossiblePlay.new(source: card, key: "counter", target: duel.player2.battlefield_creatures.first))
          pass_until_next_phase
        end

        context "their creature" do
          let(:our_creature) { duel.player2.battlefield_creatures.first }

          it "exists" do
            expect(our_creature).to_not be_nil
          end

          it "has power 3" do
            expect(our_creature.card.power).to eq(2 + 1)
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
          end

          context "in the next players turn" do
            before :each do
              pass_until_next_player
            end

            it "no longer has any effects" do
              expect(our_creature.card.effects).to be_empty
            end
          end

          context "in our next turn" do
            before :each do
              pass_until_next_player
            end

            it "no longer has any effects" do
              expect(our_creature.card.effects).to be_empty
            end
          end
        end

        context "our creature" do
          let(:our_creature) { duel.player1.battlefield_creatures.first }

          it "has power 2" do
            expect(our_creature.card.power).to eq(2)
          end

          it "has toughness 3" do
            expect(our_creature.card.toughness).to eq(3)
          end
        end
      end

    end
  end

end
