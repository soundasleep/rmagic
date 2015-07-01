require_relative "setup_game"

RSpec.describe "Creatures with a destroy ability", type: :game do
  let(:duel) { create_game }
  let(:source) { duel.player1.battlefield.select{ |b| b.card.card_type.actions.include?("destroy") }.first }
  let(:card) { source }
  let(:target) { duel.player1.battlefield_creatures.first }

  before :each do
    create_battlefield_cards Library::Metaverse6.id
    duel.playing_phase!
  end

  def destroy_actions(zone_card)
    actions(zone_card.card, "destroy")
  end

  def first_creature_available_destroy_actions
    available_ability_actions("destroy")
  end

  let(:source_actions) { source.card.card_type.actions }

  it "has a destroy ability" do
    expect(source_actions).to include("destroy")
  end

  it "exist on the battlefield" do
    expect(duel.player1.battlefield).to include(source)
  end

  let(:ability) { PossibleAbility.new(source: card, key: "destroy") }
  let(:targeted_ability) { PossibleAbility.new(source: card, key: "destroy", target: target) }
  let(:cost) { card.card.card_type.destroy_cost(game_engine, source, target) }

  context "without mana" do
    it "is not enough mana to play" do
      expect(duel.player1).to_not be_has_mana(cost)
    end

    it "requires mana" do
      expect(game_engine.can_do_action?(ability)).to be(false)
    end

    it "requires mana and a target" do
      expect(game_engine.can_do_action?(targeted_ability)).to be(false)
    end

    it "is not listed as an available action" do
      expect(first_creature_available_destroy_actions).to be_empty
    end
  end

  context "with mana" do
    before :each do
      tap_all_lands
    end

    it "is enough mana to play" do
      expect(duel.player1).to be_has_mana(cost)
    end

    context "can be played with mana" do
      it "and a target" do
        expect(game_engine.can_do_action?(targeted_ability)).to be(true)
      end

      it "but not without a target" do
        expect(game_engine.can_do_action?(ability)).to be(false)
      end
    end

    context "is listed as an available action" do
      it "of one type" do
        expect(first_creature_available_destroy_actions.to_a.uniq{ |u| u.source }.length).to eq(1)
      end

      it "of two targets" do
        expect(first_creature_available_destroy_actions.length).to eq(2)
      end

      it "with the correct source and key" do
        available_actions[:play].each do |a|
          expect(a.source).to eq(card)
          expect(a.key).to eq("destroy")
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

    context "when activated" do
      it "we have one creature" do
        expect(duel.player1.battlefield_creatures.length).to eq(1)
      end

      it "they have one creature" do
        expect(duel.player2.battlefield_creatures.length).to eq(1)
      end

      context "on our creature" do
        before :each do
          game_engine.card_action(targeted_ability)
        end

        it "removes our creature" do
          expect(duel.player1.battlefield_creatures).to be_empty
        end

        it "does not remove their creature" do
          expect(duel.player2.battlefield_creatures).to_not be_empty
        end

        it "creates an action" do
          expect(destroy_actions(card).map{ |card| card.card }).to eq([card.card])
        end

        it "consumes mana" do
          expect(duel.player1.mana_green).to eq(2)
        end
      end

      context "on their creature" do
        let(:target) { duel.player2.battlefield_creatures.first }

        before :each do
          game_engine.card_action(targeted_ability)
        end

        it "removes their creature" do
          expect(duel.player2.battlefield_creatures).to be_empty
        end

        it "does not remove our creature" do
          expect(duel.player1.battlefield_creatures).to_not be_empty
        end

        it "creates an action" do
          expect(destroy_actions(card).map{ |card| card.card }).to eq([card.card])
        end

        it "consumes mana" do
          expect(duel.player1.mana_green).to eq(2)
        end
      end

      context "after adding another creature" do
        before :each do
          create_battlefield_cards Library::Metaverse1.id
        end

        context "targeting the second creature" do
          let(:target) { duel.player1.battlefield_creatures.second }

          before :each do
            game_engine.card_action(targeted_ability)
          end

          it "removes the second creature" do
            expect(duel.player1.battlefield_creatures).to_not include(target)
          end

          it "does not remove the activated creature" do
            expect(duel.player1.battlefield_creatures).to include(source)
          end

          it "does not remove their creature" do
            expect(duel.player2.battlefield_creatures).to_not be_empty
          end
        end
      end

    end
  end

end
