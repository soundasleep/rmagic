require "game_helper"

RSpec.describe "Creature abilities", type: :game do
  let(:duel) { create_game }
  let(:card) { first_add_life_creature }

  before :each do
    create_battlefield_cards Library::Metaverse3
    duel.playing_phase!
  end

  def first_add_life_creature
    duel.player1.battlefield.select{ |b| b.card.card_type.actions.include?("add_life") }.first
  end

  def add_life_actions(zone_card)
    actions(zone_card.card, "add_life")
  end

  def first_creature_available_add_life_actions
    available_ability_actions("add_life")
  end

  let(:ability) { PossibleAbility.new(source: card, key: "add_life") }

  context "without mana" do
    it "can not be played" do
      expect(ability.can_do?(duel)).to be(false)
    end

    it "is not listed as an available action" do
      expect(first_creature_available_add_life_actions).to be_empty
    end
  end

  context "with mana" do
    before :each do
      tap_all_lands
    end

    it "can be played" do
      expect(ability.can_do?(duel)).to be(true)
    end

    it "is listed as an available action" do
      expect(first_creature_available_add_life_actions.length).to eq(1)

      action = first_creature_available_add_life_actions.first
      expect(action.source).to eq(card)
      expect(action.key).to eq("add_life")
    end

    it "all actions have source and key specified" do
      ability_cards(duel.player1).each do |a|
        expect(a.source).to_not be_nil
        expect(a.key).to_not be_nil
      end
    end

    it "all actions have a description" do
      ability_cards(duel.player1).each do |a|
        expect(a.description).to_not be_nil
      end
    end

    it "all actions do not have a target" do
      ability_cards(duel.player1).each do |a|
        expect(a.target).to be_nil
      end
    end

    context "when activated" do
      before :each do
        expect(duel.player1.life).to eq(20)
        expect(duel.player2.life).to eq(20)
        expect(duel.player1.mana_green).to eq(3)
        PossibleAbility.new(source: card, key: "add_life").do duel
      end

      it "adds life" do
        expect(duel.player1.life).to eq(20 + 1)
      end

      it "does not add life to the other player" do
        expect(duel.player2.life).to_not eq(20 + 1)
      end

      it "creates an action" do
        expect(add_life_actions(card).map{ |card| card.card }).to eq([card.card])
      end

      it "consumes mana" do
        expect(duel.player1.mana_green).to eq(2)
      end

    end
  end

  context "in our turn" do
    context "in the drawing phase" do
      before :each do
        duel.drawing_phase!
        tap_all_lands
      end

      it "cannot be activated" do
        expect(first_creature_available_add_life_actions).to be_empty
      end
    end

    context "in the playing phase" do
      before :each do
        duel.playing_phase!
        tap_all_lands
      end

      it "can be activated" do
        expect(first_creature_available_add_life_actions.length).to eq(1)
      end
    end

    context "in the attacking phase" do
      before :each do
        duel.attacking_phase!
        tap_all_lands
      end

      it "can be activated" do
        expect(first_creature_available_add_life_actions.length).to eq(1)
      end
    end

    context "in the cleanup phase" do
      before :each do
        duel.cleanup_phase!
        tap_all_lands
      end

      it "cannot be activated" do
        expect(first_creature_available_add_life_actions).to be_empty
      end
    end
  end

  context "in the other player's turn" do
    before :each do
      pass_until_next_player
    end

    context "in the drawing phase" do
      before :each do
        duel.drawing_phase!
        tap_all_lands
      end

      it "cannot be activated" do
        expect(first_creature_available_add_life_actions).to be_empty
      end
    end

    context "in the playing phase" do
      before :each do
        duel.playing_phase!
        tap_all_lands
      end

      it "cannot be activated" do
        expect(first_creature_available_add_life_actions).to be_empty
      end
    end

    context "in the attacking phase" do
      before :each do
        duel.attacking_phase!
        tap_all_lands
      end

      it "cannot be activated" do
        expect(first_creature_available_add_life_actions).to be_empty
      end
    end

    context "in the cleanup phase" do
      before :each do
        duel.cleanup_phase!
        tap_all_lands
      end

      it "cannot be activated" do
        expect(first_creature_available_add_life_actions).to be_empty
      end
    end

    context "when we have priority" do
      before :each do
        pass_until_current_player_has_priority
      end

      context "in the drawing phase" do
        before :each do
          duel.drawing_phase!
          tap_all_lands
        end

        it "cannot be activated" do
          expect(first_creature_available_add_life_actions).to be_empty
        end
      end

      context "in the playing phase" do
        before :each do
          duel.playing_phase!
          tap_all_lands
        end

        it "can be activated" do
          expect(first_creature_available_add_life_actions.length).to eq(1)
        end
      end

      context "in the attacking phase" do
        before :each do
          duel.attacking_phase!
          tap_all_lands
        end

        it "can be activated" do
          expect(first_creature_available_add_life_actions.length).to eq(1)
        end
      end

      context "in the cleanup phase" do
        before :each do
          duel.cleanup_phase!
          tap_all_lands
        end

        it "cannot be activated" do
          expect(first_creature_available_add_life_actions).to be_empty
        end
      end
    end
  end

end
