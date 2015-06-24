require_relative "setup_game"

RSpec.describe "Creatures" do
  let(:duel) { create_game }
  let(:card) { first_creature }

  before :each do
    create_hand_cards 1
    duel.playing_phase!
  end

  def first_creature
    duel.player1.hand.select{ |b| b.card.card_type.actions.include?("play") }.first
  end

  def play_actions(zone_card)
    actions(zone_card.card, "play")
  end

  def first_creature_available_play_actions
    available_play_actions("play")
  end

  it "can be created manually" do
    expect(first_creature).to_not be_nil
  end

  it "can be played in a phase which can play creatures" do
    expect(duel.phase.can_play?).to eq(true)
  end

  context "without mana" do
    it "requires mana" do
      expect(game_engine.can_do_action?(PossiblePlay.new(source: card, key: "play"))).to eq(false)
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
      expect(game_engine.can_do_action?(PossiblePlay.new(source: card, key: "play"))).to eq(true)
    end

    it "is listed as an available action" do
      expect(first_creature_available_play_actions.length).to eq(1)

      action = first_creature_available_play_actions.first
      expect(action.source).to eq(card)
      expect(action.key).to eq("play")
    end

    it "all actions have source and key specified" do
      available_actions[:play].each do |a|
        expect(a.source).to_not be_nil
        expect(a.key).to_not be_nil
      end
    end

    it "all actions have a description" do
      available_actions[:play].each do |a|
        expect(a.description).to_not be_nil
      end
    end

    it "all actions do not have a target" do
      available_actions[:play].each do |a|
        expect(a.target).to be_nil
      end
    end

    context "when played" do
      def played_creatures(player)
        player.battlefield.select{ |b| b.card.turn_played != 0 }
      end

      before :each do
        expect(played_creatures(duel.player1)).to be_empty
        expect(played_creatures(duel.player2)).to be_empty
        expect(duel.player1.mana_green).to eq(3)
        game_engine.card_action(PossiblePlay.new(source: card, key: "play"))
      end

      it "adds a creature to the battlefield" do
        expect(played_creatures(duel.player1).map{ |c| c.card }).to eq([card.card])
      end

      it "does not add a creature for the other player" do
        expect(played_creatures(duel.player2).map{ |c| c.card }).to be_empty
      end

      it "creates an action" do
        expect(play_actions(card).map{ |card| card.card }).to eq([card.card])
      end

      it "consumes mana" do
        expect(duel.player1.mana_green).to eq(1)
      end

      it "removes the creature from the hand" do
        expect(first_creature).to be_nil
      end

    end
  end

  context "in our turn" do
    context "in the drawing phase" do
      before :each do
        duel.drawing_phase!
        tap_all_lands
      end

      it "cannot be played" do
        expect(first_creature_available_play_actions).to be_empty
      end
    end

    context "in the playing phase" do
      before :each do
        duel.playing_phase!
        tap_all_lands
      end

      it "can be played" do
        expect(first_creature_available_play_actions.length).to eq(1)
      end
    end

    context "in the attacking phase" do
      before :each do
        duel.attacking_phase!
        tap_all_lands
      end

      it "cannot be played" do
        expect(first_creature_available_play_actions).to be_empty
      end
    end

    context "in the cleanup phase" do
      before :each do
        duel.cleanup_phase!
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
        duel.drawing_phase!
        tap_all_lands
      end

      it "cannot be played" do
        expect(first_creature_available_play_actions).to be_empty
      end
    end

    context "in the playing phase" do
      before :each do
        duel.playing_phase!
        tap_all_lands
      end

      it "cannot be played" do
        expect(first_creature_available_play_actions).to be_empty
      end
    end

    context "in the attacking phase" do
      before :each do
        duel.attacking_phase!
        tap_all_lands
      end

      it "cannot be played" do
        expect(first_creature_available_play_actions).to be_empty
      end
    end

    context "in the cleanup phase" do
      before :each do
        duel.cleanup_phase!
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
          duel.drawing_phase!
          tap_all_lands
        end

        it "cannot be played" do
          expect(first_creature_available_play_actions).to be_empty
        end
      end

      context "in the playing phase" do
        before :each do
          duel.playing_phase!
          tap_all_lands
        end

        it "cannot be played" do
          expect(first_creature_available_play_actions).to be_empty
        end
      end

      context "in the attacking phase" do
        before :each do
          duel.attacking_phase!
          tap_all_lands
        end

        it "cannot be played" do
          expect(first_creature_available_play_actions).to be_empty
        end
      end

      context "in the cleanup phase" do
        before :each do
          duel.cleanup_phase!
          tap_all_lands
        end

        it "cannot be played" do
          expect(first_creature_available_play_actions).to be_empty
        end
      end
    end
  end

end
