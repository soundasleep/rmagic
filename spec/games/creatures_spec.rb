require_relative "setup_game"

RSpec.describe "Creatures" do
  before :each do
    setup

    create_hand_cards 1
    @duel.playing_phase!

    @card = first_creature
  end

  def first_creature
    @duel.player1.hand.select{ |b| b.entity.find_card.actions.include?("play") }.first
  end

  def play_actions(card)
    actions(card.entity, "play")
  end

  def first_creature_available_play_actions
    available_play_actions("play")
  end

  it "can be created manually" do
    expect(first_creature).to_not be_nil
  end

  context "without mana" do
    it "requires mana" do
      expect(game_engine.can_do_action?(@card, "play")).to eq(false)
    end

    it "is not listed as an available action" do
      expect(first_creature_available_play_actions).to be_empty
    end
  end

  context "with mana" do
    before :each do
      tap_all_lands
    end

    it "can be played with mana" do
      expect(game_engine.can_do_action?(@card, "play")).to eq(true)
    end

    it "is listed as an available action" do
      expect(first_creature_available_play_actions.length).to eq(1)

      action = first_creature_available_play_actions.first
      expect(action[:source]).to eq(@card)
      expect(action[:action]).to eq("play")
    end

    it "all actions have :source and :action specified" do
      available_actions[:play].each do |a|
        expect(a[:source]).to_not be_nil
        expect(a[:action]).to_not be_nil
      end
    end

    context "when played" do
      def played_creatures(player)
        player.battlefield.select{ |b| b.entity.turn_played != 0 }
      end

      before :each do
        expect(played_creatures(@duel.player1)).to be_empty
        expect(played_creatures(@duel.player2)).to be_empty
        expect(@duel.player1.mana_green).to eq(3)
        game_engine.card_action(@card, "play")
      end

      it "adds a creature to the battlefield" do
        expect(played_creatures(@duel.player1).map{ |c| c.entity }).to eq([@card.entity])
      end

      it "does not add a creature for the other player" do
        expect(played_creatures(@duel.player2).map{ |c| c.entity }).to be_empty
      end

      it "creates an action" do
        expect(play_actions(@card).map{ |card| card.entity }).to eq([@card.entity])
      end

      it "consumes mana" do
        expect(@duel.player1.mana_green).to eq(1)
      end

    end
  end

  context "in our turn" do
    context "in the drawing phase" do
      before :each do
        @duel.drawing_phase!
        tap_all_lands
      end

      it "cannot be played" do
        expect(first_creature_available_play_actions).to be_empty
      end
    end

    context "in the playing phase" do
      before :each do
        @duel.playing_phase!
        tap_all_lands
      end

      it "can be played" do
        expect(first_creature_available_play_actions.length).to eq(1)
      end
    end

    context "in the attacking phase" do
      before :each do
        @duel.attacking_phase!
        tap_all_lands
      end

      it "cannot be played" do
        expect(first_creature_available_play_actions).to be_empty
      end
    end

    context "in the cleanup phase" do
      before :each do
        @duel.cleanup_phase!
        tap_all_lands
      end

      it "cannot be played" do
        expect(first_creature_available_play_actions).to be_empty
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

      it "cannot be played" do
        expect(first_creature_available_play_actions).to be_empty
      end
    end

    context "in the playing phase" do
      before :each do
        @duel.playing_phase!
        tap_all_lands
      end

      it "cannot be played" do
        expect(first_creature_available_play_actions).to be_empty
      end
    end

    context "in the attacking phase" do
      before :each do
        @duel.attacking_phase!
        tap_all_lands
      end

      it "cannot be played" do
        expect(first_creature_available_play_actions).to be_empty
      end
    end

    context "in the cleanup phase" do
      before :each do
        @duel.cleanup_phase!
        tap_all_lands
      end

      it "cannot be played" do
        expect(first_creature_available_play_actions).to be_empty
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

        it "cannot be played" do
          expect(first_creature_available_play_actions).to be_empty
        end
      end

      context "in the playing phase" do
        before :each do
          @duel.playing_phase!
          tap_all_lands
        end

        it "cannot be played" do
          expect(first_creature_available_play_actions).to be_empty
        end
      end

      context "in the attacking phase" do
        before :each do
          @duel.attacking_phase!
          tap_all_lands
        end

        it "cannot be played" do
          expect(first_creature_available_play_actions).to be_empty
        end
      end

      context "in the cleanup phase" do
        before :each do
          @duel.cleanup_phase!
          tap_all_lands
        end

        it "cannot be played" do
          expect(first_creature_available_play_actions).to be_empty
        end
      end
    end
  end

end
