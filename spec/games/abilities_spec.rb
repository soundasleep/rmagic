require_relative "setup_game"

RSpec.describe "Abilities" do
  before :each do
    setup

    create_ability_creatures

    @card = first_add_life_creature
  end

  def first_add_life_creature
    @duel.player1.battlefield.select{ |b| b.entity.find_card.actions.include?("add_life") }.first
  end

  context "instant add_life ability" do
    def add_life_actions(card)
      actions(card.entity, "add_life")
    end

    def available_add_life_actions
      available_actions[:ability].select { |action| action[:action] == "add_life" }
    end

    context "without mana" do
      it "requires mana" do
        expect(game_engine.can_do_action?(@card, "add_life")).to eq(false)
      end

      it "is not listed as an available action" do
        expect(available_add_life_actions).to be_empty
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
        expect(available_add_life_actions.length).to eq(1)

        action = available_add_life_actions.first
        expect(action[:source]).to eq(@card)
        expect(action[:action]).to eq("add_life")
      end

      it "all actions have :source and :action specified" do
        available_actions[:ability].each do |a|
          expect(a[:source]).to_not be_nil
          expect(a[:action]).to_not be_nil
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
          expect(add_life_actions(@card).map{ |card| card.entity }).to eq([@card.entity])
        end

        it "consumes mana" do
          expect(@duel.player1.mana_green).to eq(2)
        end

      end
    end

  end

  context "lands" do
    def tap_actions(card)
      actions(card.entity, "tap")
    end

    def available_ability_actions(index)
      available_actions[:ability].select { |action| action[:action] == index }
    end

    def first_land
      @duel.player1.battlefield.select{ |b| b.entity.find_card.is_land? }.first
    end

    def first_land_available_tap_actions
      available_ability_actions("tap").select{ |a| a[:source].entity == first_land.entity }
    end

    def first_land_available_untap_actions
      available_ability_actions("untap").select{ |a| a[:source].entity == first_land.entity }
    end

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
