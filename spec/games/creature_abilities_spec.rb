require_relative "setup_game"

RSpec.describe "Creature abilities" do
  before :each do
    setup

    create_battlefield_cards 3
    @duel.playing_phase!

    @card = first_add_life_creature
  end

  def first_add_life_creature
    @duel.player1.battlefield.select{ |b| b.card.card_type.actions.include?("add_life") }.first
  end

  def add_life_actions(zone_card)
    actions(zone_card.card, "add_life")
  end

  def first_creature_available_add_life_actions
    available_ability_actions("add_life")
  end

  context "without mana" do
    it "requires mana" do
      expect(game_engine.can_do_action?(@card, "add_life")).to eq(false)
    end

    it "is not listed as an available action" do
      expect(first_creature_available_add_life_actions).to be_empty
    end
  end

  context "with mana" do
    before :each do
      tap_all_lands
    end

    it "can be played with mana" do
      expect(game_engine.can_do_action?(@card, "add_life")).to eq(true)
    end

    it "is listed as an available action" do
      expect(first_creature_available_add_life_actions.length).to eq(1)

      action = first_creature_available_add_life_actions.first
      expect(action.source).to eq(@card)
      expect(action.key).to eq("add_life")
    end

    it "all actions have source and key specified" do
      available_actions[:ability].each do |a|
        expect(a.source).to_not be_nil
        expect(a.key).to_not be_nil
      end
    end

    it "all actions have a description" do
      available_actions[:ability].each do |a|
        expect(a.description).to_not be_nil
      end
    end

    it "all actions do not have a target" do
      available_actions[:ability].each do |a|
        expect(a.target).to be_nil
      end
    end

    context "when activated" do
      before :each do
        expect(@duel.player1.life).to eq(20)
        expect(@duel.player2.life).to eq(20)
        expect(@duel.player1.mana_green).to eq(3)
        game_engine.card_action(@card, "add_life")
      end

      it "adds life" do
        expect(@duel.player1.life).to eq(20 + 1)
      end

      it "does not add life to the other player" do
        expect(@duel.player2.life).to_not eq(20 + 1)
      end

      it "creates an action" do
        expect(add_life_actions(@card).map{ |card| card.card }).to eq([@card.card])
      end

      it "consumes mana" do
        expect(@duel.player1.mana_green).to eq(2)
      end

    end
  end

  context "in our turn" do
    context "in the drawing phase" do
      before :each do
        @duel.drawing_phase!
        tap_all_lands
      end

      it "cannot be activated" do
        expect(first_creature_available_add_life_actions).to be_empty
      end
    end

    context "in the playing phase" do
      before :each do
        @duel.playing_phase!
        tap_all_lands
      end

      it "can be activated" do
        expect(first_creature_available_add_life_actions.length).to eq(1)
      end
    end

    context "in the attacking phase" do
      before :each do
        @duel.attacking_phase!
        tap_all_lands
      end

      it "can be activated" do
        expect(first_creature_available_add_life_actions.length).to eq(1)
      end
    end

    context "in the cleanup phase" do
      before :each do
        @duel.cleanup_phase!
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
        @duel.drawing_phase!
        tap_all_lands
      end

      it "cannot be activated" do
        expect(first_creature_available_add_life_actions).to be_empty
      end
    end

    context "in the playing phase" do
      before :each do
        @duel.playing_phase!
        tap_all_lands
      end

      it "cannot be activated" do
        expect(first_creature_available_add_life_actions).to be_empty
      end
    end

    context "in the attacking phase" do
      before :each do
        @duel.attacking_phase!
        tap_all_lands
      end

      it "cannot be activated" do
        expect(first_creature_available_add_life_actions).to be_empty
      end
    end

    context "in the cleanup phase" do
      before :each do
        @duel.cleanup_phase!
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
          @duel.drawing_phase!
          tap_all_lands
        end

        it "cannot be activated" do
          expect(first_creature_available_add_life_actions).to be_empty
        end
      end

      context "in the playing phase" do
        before :each do
          @duel.playing_phase!
          tap_all_lands
        end

        it "can be activated" do
          expect(first_creature_available_add_life_actions.length).to eq(1)
        end
      end

      context "in the attacking phase" do
        before :each do
          @duel.attacking_phase!
          tap_all_lands
        end

        it "can be activated" do
          expect(first_creature_available_add_life_actions.length).to eq(1)
        end
      end

      context "in the cleanup phase" do
        before :each do
          @duel.cleanup_phase!
          tap_all_lands
        end

        it "cannot be activated" do
          expect(first_creature_available_add_life_actions).to be_empty
        end
      end
    end
  end

end
