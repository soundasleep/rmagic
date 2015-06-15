require_relative "setup_game"

RSpec.describe "Lands" do
  before :each do
    setup

    create_hand_cards 2
    @duel.playing_phase!
  end

  def tap_actions(card)
    actions(card.entity, "tap")
  end

  def first_land
    @duel.player1.battlefield.select{ |b| b.entity.find_card.is_land? }.first
  end

  def first_hand_land
    @duel.player1.hand.select{ |b| b.entity.find_card.is_land? }.first
  end

  def first_land_available_tap_actions
    available_ability_actions("tap").select{ |a| a[:source].entity == first_land.entity }
  end

  def first_land_available_untap_actions
    available_ability_actions("untap").select{ |a| a[:source].entity == first_land.entity }
  end

  context "in the hand" do
    it "exists" do
      expect(first_hand_land).to_not be_nil
    end

    it "is different from one in the battlefield" do
      expect(first_land).to_not eq(first_hand_land)
    end

    it "cannot be tapped" do
      actions = available_play_actions("tap").select{ |a| a[:source].entity == first_hand_land.entity }
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
        game_engine.card_action(first_land, "tap")
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
