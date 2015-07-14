require "game_helper"

RSpec.describe "Tapping lands", type: :game do
  let(:duel) { create_game }

  before :each do
    duel.playing_phase!
  end

  def untapped_land
    result = untapped_lands

    fail "No untapped land found: #{result}" unless result.first and result.first != nil
    return result.first
  end

  def untapped_lands
    duel.player1.battlefield_lands.select { |b| !b.card.is_tapped? }
  end

  it "can be tapped in a phase which can be tapped" do
    expect(duel.phase.can_tap?).to be(true)
  end

  it "we can tap forests to get green mana" do
    expect(duel.player1.mana_green).to eq(0)
    expect(untapped_land.player).to eq(duel.player1)

    game_engine.card_action(PossibleAbility.new(source: untapped_land, key: "tap"))
    expect(duel.player1.mana_green).to eq(1)

    game_engine.card_action(PossibleAbility.new(source: untapped_land, key: "tap"))
    expect(duel.player1.mana_green).to eq(2)
  end

  context "an untapped land" do
    let(:battlefield) { untapped_land }
    let(:ability) { PossibleAbility.new(source: battlefield, key: "tap") }

    it "can be tapped" do
      expect(battlefield.card.is_tapped?).to be(false)
      game_engine.card_action(ability)
      battlefield.reload
      battlefield.card.reload
      expect(battlefield.card.is_tapped?).to be(true)
    end

    context "and when tapped" do
      before :each do
        expect(ActionLog.where(duel: duel)).to be_empty
        game_engine.card_action(ability)
      end

      it "can no longer be actioned to tap" do
        expect(ability.can_do?(duel)).to be(false)
      end

      it "creates an action log" do
        action = ActionLog.where(duel: duel).first!
        expect(action.card).to eq(battlefield.card)
      end

      it "does not modify the phase of the duel" do
        expect(duel.playing_phase?).to be(true)
      end
    end

    it "can be tapped directly" do
      expect(battlefield.card.is_tapped?).to be(false)
      battlefield.card.tap_card!
      expect(battlefield.card.is_tapped?).to be(true)
    end

    it "does not tap other lands" do
      battlefield.card.tap_card!

      card = untapped_land
      expect(card.card).to_not eq(battlefield.card)
      expect(card.card.is_tapped?).to be(false)
    end

    it "can be actioned to tap" do
      expect(ability.can_do?(duel)).to be(true)
    end
  end

  it "tapped lands untap in the next turn" do
    tap_all_lands
    expect(untapped_lands).to be_empty

    pass_until_next_turn
    expect(untapped_lands).to_not be_empty
  end

  it "tapped lands do not untap in the next players current turn" do
    tap_all_lands
    expect(untapped_lands).to be_empty
    turn = duel.turn

    pass_until_next_player
    expect(untapped_lands).to be_empty
    expect(duel.turn).to eq(turn)

    pass_until_next_player
    expect(untapped_lands).to_not be_empty
    expect(duel.turn).to_not eq(turn)
  end

  context "tapped mana" do
    before { tap_all_lands }

    it "exists" do
      expect(duel.player1.mana_green).to eq(3)
    end

    context "after passing to the next player in this phase" do
      before { game_engine.pass }

      it "persists" do
        expect(duel.player1.mana_green).to eq(3)
      end
    end

    context "after passing to the next phase" do
      before { pass_until_next_phase }

      it "is removed" do
        expect(duel.player1.mana_green).to eq(0)
      end
    end
  end

end
