require_relative "setup_game"

RSpec.describe "Creatures with a destroy ability", type: :game do
  let(:duel) { create_game }
  let(:card) { first_destroy_creature }

  before :each do
    create_battlefield_cards Library::Metaverse6
    duel.playing_phase!
  end

  def first_destroy_creature
    duel.player1.battlefield.select{ |b| b.card.card_type.actions.include?("destroy") }.first
  end

  def destroy_actions(zone_card)
    actions(zone_card.card, "destroy")
  end

  def first_creature_available_destroy_actions
    available_ability_actions("destroy")
  end

  it "has a destroy ability" do
    battlefield = duel.player1.battlefield.last
    expect(battlefield.card.card_type.actions).to include("destroy")
  end

  it "exist on the battlefield" do
    expect(duel.player1.battlefield).to include(first_destroy_creature)
  end

  context "without mana" do
    it "is not enough mana to play" do
      card = first_destroy_creature
      expect(duel.player1.has_mana?(card.card.card_type.destroy_cost(game_engine, card, first_destroy_creature))).to be(false)
    end

    it "requires mana" do
      expect(game_engine.can_do_action?(PossibleAbility.new(source: card, key: "destroy"))).to be(false)
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
      card = first_destroy_creature
      expect(duel.player1.has_mana?(card.card.card_type.destroy_cost(game_engine, card, first_destroy_creature))).to be(true)
    end

    context "can be played with mana" do
      it "and a target" do
        expect(game_engine.can_do_action?(PossibleAbility.new(source: card, key: "destroy", target: duel.player1.battlefield_creatures.first))).to be(true)
      end

      it "but not without a target" do
        expect(game_engine.can_do_action?(PossibleAbility.new(source: card, key: "destroy"))).to be(false)
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
        playable_cards(duel.player1).each do |a|
          expect(a.source).to eq(card)
          expect(a.key).to eq("destroy")
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

    context "when activated" do
      it "we have one creature" do
        expect(duel.player1.battlefield_creatures.length).to eq(1)
      end

      it "they have one creature" do
        expect(duel.player2.battlefield_creatures.length).to eq(1)
      end

      context "on our creature" do
        before :each do
          game_engine.card_action(PossibleAbility.new(source: card, key: "destroy", target: duel.player1.battlefield_creatures.first))
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
        before :each do
          game_engine.card_action(PossibleAbility.new(source: card, key: "destroy", target: duel.player2.battlefield_creatures.first))
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
          create_battlefield_cards Library::Metaverse1
        end

        context "targeting the second creature" do
          let(:target) { duel.player1.battlefield_creatures.second }

          before :each do
            game_engine.card_action(PossibleAbility.new(source: card, key: "destroy", target: target))
          end

          it "removes the second creature" do
            expect(duel.player1.battlefield_creatures).to_not include(target)
          end

          it "does not remove the activated creature" do
            expect(duel.player1.battlefield_creatures).to include(first_destroy_creature)
          end

          it "does not remove their creature" do
            expect(duel.player2.battlefield_creatures).to_not be_empty
          end
        end
      end

    end
  end

end
