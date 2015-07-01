require_relative "setup_game"

RSpec.describe "Creature abilities", type: :game do
  let(:duel) { create_game }
  let(:ability_key) { "add_life" }
  let(:source) { player1.battlefield.select{ |b| b.card.card_type.actions.include?(ability_key) }.first }
  let(:target) { player1.battlefield_creatures.first }
  let(:ability) { PossibleAbility.new(source: source, key: ability_key) }
  let(:available_abilities) { available_ability_actions(ability_key) }

  before :each do
    create_battlefield_cards Library::Metaverse3.id
    duel.playing_phase!
  end

  def add_life_actions(zone_card)
    actions(zone_card.card, "add_life")
  end

  it_behaves_like "requires mana"
  it_behaves_like "ability"

  context "with mana" do
    before :each do
      tap_all_lands
    end

    context "when activated" do
      before :each do
        expect(duel.player1.life).to eq(20)
        expect(duel.player2.life).to eq(20)
        expect(duel.player1.mana_green).to eq(3)
        game_engine.card_action(PossibleAbility.new(source: source, key: "add_life"))
      end

      it "adds life" do
        expect(duel.player1.life).to eq(20 + 1)
      end

      it "does not add life to the other player" do
        expect(duel.player2.life).to_not eq(20 + 1)
      end

      it "creates an action" do
        expect(add_life_actions(source).map{ |card| card.card }).to eq([source.card])
      end

      it "consumes mana" do
        expect(duel.player1.mana_green).to eq(2)
      end

    end
  end

  it_behaves_like "not available in other turns"
  it_behaves_like "not available in drawing phase"
  it_behaves_like "available in playing phase"
  it_behaves_like "available in attacking phase"
  it_behaves_like "not available in cleanup phase"

end
