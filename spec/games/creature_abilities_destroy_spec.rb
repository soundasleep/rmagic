require_relative "setup_game"

RSpec.describe "Creatures with a destroy ability", type: :game do
  let(:duel) { create_game }
  let(:ability_key) { "destroy" }
  let(:source) { player1.battlefield.select{ |b| b.card.card_type.actions.include?(ability_key) }.first }
  let(:target) { player1.battlefield_creatures.first }
  let(:ability) { PossibleAbility.new(source: source, key: ability_key) }
  let(:targeted_ability) { PossibleAbility.new(source: source, key: ability_key, target: target) }
  let(:available_abilities) { available_ability_actions(ability_key) }

  before :each do
    create_battlefield_cards Library::Metaverse6.id
    duel.playing_phase!
  end

  def destroy_actions(zone_card)
    actions(zone_card.card, "destroy")
  end

  it_behaves_like "requires mana"
  it_behaves_like "targeted ability"
  it_behaves_like "something on the battlefield"

  context "with mana" do
    before :each do
      tap_all_lands
    end

    context "when activated" do
      it "we have one creature" do
        expect(player1.battlefield_creatures.length).to eq(1)
      end

      it "they have one creature" do
        expect(player2.battlefield_creatures.length).to eq(1)
      end

      context "on our creature" do
        before :each do
          game_engine.card_action(targeted_ability)
        end

        it "removes our creature" do
          expect(player1.battlefield_creatures).to be_empty
        end

        it "does not remove their creature" do
          expect(player2.battlefield_creatures).to_not be_empty
        end

        it "creates an action" do
          expect(destroy_actions(source).map{ |card| card.card }).to eq([source.card])
        end

        it "consumes mana" do
          expect(player1.mana_green).to eq(2)
        end
      end

      context "on their creature" do
        let(:target) { player2.battlefield_creatures.first }

        before :each do
          game_engine.card_action(targeted_ability)
        end

        it "removes their creature" do
          expect(player2.battlefield_creatures).to be_empty
        end

        it "does not remove our creature" do
          expect(player1.battlefield_creatures).to_not be_empty
        end

        it "creates an action" do
          expect(destroy_actions(source).map{ |card| card.card }).to eq([source.card])
        end

        it "consumes mana" do
          expect(player1.mana_green).to eq(2)
        end
      end

      context "after adding another creature" do
        before :each do
          create_battlefield_cards Library::Metaverse1.id
        end

        context "targeting the second creature" do
          let(:target) { player1.battlefield_creatures.second }

          before :each do
            game_engine.card_action(targeted_ability)
          end

          it "removes the second creature" do
            expect(player1.battlefield_creatures).to_not include(target)
          end

          it "does not remove the activated creature" do
            expect(player1.battlefield_creatures).to include(source)
          end

          it "does not remove their creature" do
            expect(player2.battlefield_creatures).to_not be_empty
          end
        end
      end

    end
  end

end
