require_relative "setup_game"

RSpec.describe "Tapping lands" do
  before :each do
    setup

    @duel.playing_phase!
  end

  def untapped_land
    result = untapped_lands

    fail "No untapped land found: #{result}" unless result.first and result.first != nil
    return result.first
  end

  def untapped_lands
    @duel.player1.battlefield.select { |b| !b.entity.is_tapped? && b.entity.find_card.is_land? }
  end

  it "can be tapped in a phase which can be tapped" do
    expect(@duel.phase.can_tap?).to eq(true)
  end

  it "we can tap forests to get green mana" do
    expect(@duel.player1.mana_green).to eq(0)
    expect(untapped_land.player).to eq(@duel.player1)

    game_engine.card_action(untapped_land, "tap")
    expect(@duel.player1.mana_green).to eq(1)

    game_engine.card_action(untapped_land, "tap")
    expect(@duel.player1.mana_green).to eq(2)
  end

  context "an untapped land" do
    before :each do
      @card = untapped_land
    end

    it "can be tapped" do
      expect(@card.entity.is_tapped?).to eq(false)
      game_engine.card_action(@card, "tap")
      @card.reload
      @card.entity.reload
      expect(@card.entity.is_tapped?).to eq(true)
    end

    context "and when tapped" do
      before :each do
        expect(ActionLog.where(duel: @duel)).to be_empty
        game_engine.card_action(@card, "tap")
      end

      it "can no longer be actioned to tap" do
        expect(game_engine.can_do_action?(@card, "tap")).to eq(false)
      end

      it "creates an action log" do
        action = ActionLog.where(duel: @duel).first!
        expect(action.entity).to eq(@card.entity)
      end

      it "does not modify the phase of the duel" do
        expect(@duel.playing_phase?).to eq(true)
      end
    end

    it "can be tapped directly" do
      expect(@card.entity.is_tapped?).to eq(false)
      @card.entity.tap_card!
      expect(@card.entity.is_tapped?).to eq(true)
    end

    it "does not tap other lands" do
      @card.entity.tap_card!

      card = untapped_land
      expect(card.entity).to_not eq(@card.entity)
      expect(card.entity.is_tapped?).to eq(false)
    end

    it "can be actioned to tap" do
      expect(game_engine.can_do_action?(@card, "tap")).to eq(true)
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
    turn = @duel.turn

    pass_until_next_player
    expect(untapped_lands).to be_empty
    expect(@duel.turn).to eq(turn)

    pass_until_next_player
    expect(untapped_lands).to_not be_empty
    expect(@duel.turn).to_not eq(turn)
  end

  it "tapped mana disappears after a pass" do
    expect(@duel.player1.mana_green).to eq(0)

    tap_all_lands
    expect(@duel.player1.mana_green).to eq(3)

    game_engine.pass

    expect(@duel.player1.mana_green).to eq(0)
  end

end
