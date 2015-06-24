require_relative "setup_game"

RSpec.describe "Drawing" do
  let(:duel) { create_game }

  context "default" do
    it "starts in drawing phase" do
      expect(duel.drawing_phase?).to be(true)
    end
  end

  it "starting a new turn draws a card" do
    expect(duel.player1.hand.count).to eq(0)
    expect(duel.player2.hand.count).to eq(0)

    duel.cleanup_phase!
    duel.current_player_number = 2
    duel.priority_player_number = 2

    expect(duel.cleanup_phase?).to be(true)
    expect(duel.drawing_phase?).to be(false)

    game_engine.pass

    expect(duel.cleanup_phase?).to be(true)
    expect(duel.drawing_phase?).to be(false)
    expect(duel.player1.hand.count).to eq(0)
    expect(duel.player2.hand.count).to eq(0)

    game_engine.pass

    expect(duel.cleanup_phase?).to be(false)
    expect(duel.drawing_phase?).to be(true)
    expect(duel.player1.hand.count).to eq(1)
    expect(duel.player2.hand.count).to eq(0)
  end

  it "starting a new turn draws a card for the other player" do
    expect(duel.player1.hand.count).to eq(0)
    expect(duel.player2.hand.count).to eq(0)

    duel.cleanup_phase!
    duel.current_player_number = 1
    duel.priority_player_number = 1
    duel.save!

    game_engine.pass

    expect(duel.cleanup_phase?).to be(true)
    expect(duel.drawing_phase?).to be(false)
    expect(duel.player1.hand.count).to eq(0)
    expect(duel.player2.hand.count).to eq(0)

    game_engine.pass

    expect(duel.cleanup_phase?).to be(false)
    expect(duel.drawing_phase?).to be(true)
    expect(duel.player1.hand.count).to eq(0)
    expect(duel.player2.hand.count).to eq(1)
  end

end
