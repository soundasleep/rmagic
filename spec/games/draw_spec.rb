require_relative "setup_game"

RSpec.describe "Drawing" do
  before :each do
    setup
  end

  it "starting a new turn draws a card" do
    expect(@duel.player1.hand.count).to eq(0)
    expect(@duel.player2.hand.count).to eq(0)

    @duel.phase_number = @duel.total_phases
    @duel.current_player_number = 2
    @duel.priority_player_number = 2

    @duel.pass

    expect(@duel.player1.hand.count).to eq(0)
    expect(@duel.player2.hand.count).to eq(0)

    @duel.pass

    expect(@duel.phase_number).to eq(1)
    expect(@duel.player1.hand.count).to eq(1)
    expect(@duel.player2.hand.count).to eq(0)
  end

  it "starting a new turn draws a card for the other player" do
    expect(@duel.player1.hand.count).to eq(0)
    expect(@duel.player2.hand.count).to eq(0)

    @duel.phase_number = @duel.total_phases
    @duel.current_player_number = 1
    @duel.priority_player_number = 1

    @duel.pass

    expect(@duel.player1.hand.count).to eq(0)
    expect(@duel.player2.hand.count).to eq(0)

    @duel.pass

    expect(@duel.phase_number).to eq(1)
    expect(@duel.player1.hand.count).to eq(0)
    expect(@duel.player2.hand.count).to eq(1)
  end

end
