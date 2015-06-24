require_relative "setup_game"

RSpec.describe "Lands" do
  before :each do
    setup

    create_hand_cards 2
    @duel.playing_phase!

    @card = first_hand_land
  end

  def tap_actions(zone_card)
    actions(zone_card.card, "tap")
  end

  def play_actions(zone_card)
    actions(zone_card.card, "play")
  end

  def first_land
    @duel.player1.battlefield.select{ |b| b.card.card_type.is_land? }.first
  end

  def first_hand_land
    @duel.player1.hand.select{ |b| b.card.card_type.is_land? }.first
  end

  def first_hand_land_available_play_actions
    available_play_actions("play").select{ |a| a.source.card == first_hand_land.card }
  end

  def first_land_available_tap_actions
    available_ability_actions("tap").select{ |a| a.source.card == first_land.card }
  end

  def first_land_available_untap_actions
    available_ability_actions("untap").select{ |a| a.source.card == first_land.card }
  end

  it "can be created manually" do
    expect(first_land).to_not be_nil
  end

  context "with mana" do
    before :each do
      tap_all_lands
    end

    it "can be played with mana" do
      expect(game_engine.can_do_action?(PossiblePlay.new(source: @card, key: "play"))).to eq(true)
    end

    it "are listed as an available action" do
      expect(first_hand_land_available_play_actions.length).to eq(1)

      action = first_hand_land_available_play_actions.first
      expect(action.source).to eq(@card)
      expect(action.key).to eq("play")
    end
  end

  context "without mana" do
    it "can be played with mana" do
      expect(game_engine.can_do_action?(PossiblePlay.new(source: @card, key: "play"))).to eq(true)
    end

    it "are listed as an available action" do
      expect(first_hand_land_available_play_actions.length).to eq(1)

      action = first_hand_land_available_play_actions.first
      expect(action.source).to eq(@card)
      expect(action.key).to eq("play")
    end

    it "all actions have source and key specified" do
      available_actions[:play].each do |a|
        expect(a.source).to_not be_nil
        expect(a.key).to_not be_nil
      end
    end

    it "all actions do not have a target" do
      available_actions[:play].each do |a|
        expect(a.target).to be_nil
      end
    end

    it "all actions have a description specified" do
      available_actions[:play].each do |a|
        expect(a.description).to_not be_nil
      end
    end

    context "when played" do
      def played_lands(player)
        player.battlefield.select{ |b| b.card.turn_played != 0 }
      end

      before :each do
        expect(played_lands(@duel.player1)).to be_empty
        expect(played_lands(@duel.player2)).to be_empty
        game_engine.card_action(PossiblePlay.new(source: @card, key: "play"))
      end

      it "adds a creature to the battlefield" do
        expect(played_lands(@duel.player1).map{ |c| c.card }).to eq([@card.card])
      end

      it "does not add a creature for the other player" do
        expect(played_lands(@duel.player2).map{ |c| c.card }).to be_empty
      end

      it "creates an action" do
        expect(play_actions(@card).map{ |card| card.card }).to eq([@card.card])
      end

      it "removes the land from the hand" do
        expect(first_hand_land).to be_nil
      end

    end
  end

  context "in the hand" do
    it "exists" do
      expect(first_hand_land).to_not be_nil
    end

    it "is different from one in the battlefield" do
      expect(first_land).to_not eq(first_hand_land)
    end

    it "cannot be tapped" do
      actions = available_play_actions("tap").select{ |a| a.source.card == first_hand_land.card }
      expect(actions).to be_empty
    end
  end

  context "in the battlefield" do
    context "in our turn" do
      context "in the drawing phase" do
        before :each do
          @duel.drawing_phase!
        end

        it "cannot be tapped" do
          expect(first_land_available_tap_actions).to be_empty
        end
      end

      context "in the playing phase" do
        before :each do
          @duel.playing_phase!
        end

        it "can be tapped" do
          expect(first_land_available_tap_actions.length).to eq(1)
        end
      end

      context "in the attacking phase" do
        before :each do
          @duel.attacking_phase!
        end

        it "can be tapped" do
          expect(first_land_available_tap_actions.length).to eq(1)
        end
      end

      context "in the cleanup phase" do
        before :each do
          @duel.cleanup_phase!
        end

        it "cannot be tapped" do
          expect(first_land_available_tap_actions).to be_empty
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
        end

        it "cannot be tapped" do
          expect(first_land_available_tap_actions).to be_empty
        end
      end

      context "in the playing phase" do
        before :each do
          @duel.playing_phase!
        end

        it "cannot be tapped" do
          expect(first_land_available_tap_actions).to be_empty
        end
      end

      context "in the attacking phase" do
        before :each do
          @duel.attacking_phase!
        end

        it "cannot be tapped" do
          expect(first_land_available_tap_actions).to be_empty
        end
      end

      context "in the cleanup phase" do
        before :each do
          @duel.cleanup_phase!
        end

        it "cannot be tapped" do
          expect(first_land_available_tap_actions).to be_empty
        end
      end

      context "when we have priority" do
        before :each do
          pass_until_current_player_has_priority
        end

        context "in the drawing phase" do
          before :each do
            @duel.drawing_phase!
          end

          it "cannot be tapped" do
            expect(first_land_available_tap_actions).to be_empty
          end
        end

        context "in the playing phase" do
          before :each do
            @duel.playing_phase!
          end

          it "can be tapped" do
            expect(first_land_available_tap_actions.length).to eq(1)
          end
        end

        context "in the attacking phase" do
          before :each do
            @duel.attacking_phase!
          end

          it "can be tapped" do
            expect(first_land_available_tap_actions.length).to eq(1)
          end
        end

        context "in the cleanup phase" do
          before :each do
            @duel.cleanup_phase!
          end

          it "cannot be tapped" do
            expect(first_land_available_tap_actions).to be_empty
          end
        end
      end
    end

    context "after being tapped" do
      before :each do
        game_engine.card_action(PossibleAbility.new(source: first_land, key: "tap"))
      end

      it "cannot be untapped" do
        expect(first_land_available_untap_actions).to be_empty
      end
    end

    it "never have a play action" do
      expect(available_ability_actions("play")).to be_empty
    end
  end

end
