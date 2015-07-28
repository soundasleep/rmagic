require "game_helper"

RSpec.describe Library::ElvishMystic, type: :card do
  let(:duel) { create_game }

  before :each do
    create_battlefield_cards Library::ElvishMystic
  end

  let(:card) { player1.battlefield.select { |c| c.card.card_type.actions.include?("ability") }.first }
  let(:play_ability) { AbilityAction.new(source: card, key: "ability") }
  let(:play_conditions) { play_ability.conditions }
  let(:play_result) { play_conditions.evaluate_with(duel) }

  context "our card" do
    before { duel.playing_phase! }

    it "is not tapped" do
      expect(card.card.is_tapped?).to be(false)
    end

    it "we have no mana" do
      expect(player1.mana_pool).to be_empty
    end

    it "can be activated" do
      expect(play_result.evaluate).to be(true), play_result.explain
    end

    context "when activated" do
      before { play_ability.do(duel) }

      it "we have mana" do
        expect(player1.mana_pool).to_not be_empty
      end

      it "we have 1 green mana" do
        expect(player1.mana_green).to eq(1)
      end

      it "the card is tapped" do
        expect(card.card.is_tapped?).to be(true)
      end

      it "cannot be activated again" do
        expect(play_result.evaluate).to be(false), play_result.explain
      end
    end
  end

end
