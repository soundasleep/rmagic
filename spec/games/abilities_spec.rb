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
      end
    end

  end

end
