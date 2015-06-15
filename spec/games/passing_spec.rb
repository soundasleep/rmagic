require_relative "setup_game"

RSpec.describe "Passing" do
  before :each do
    setup

    @phases = PhaseManager.new(game_engine)

    allow(@duel).to receive(:next_phase!) {
      # we just pass through phases instantly
      true
    }
  end

  it "starting a new turn draws a card" do
    [
      [1, :drawing_phase, 1],
      [1, :drawing_phase, 2],
      [2, :drawing_phase, 2],
      [2, :drawing_phase, 1],
    ].each do |test|
      expect([@duel.current_player_number, @duel.phase, @duel.priority_player_number]).to eq(test)
      expect(@duel.turn).to eq(1), "at turn #{test}"
      @phases.pass!
    end

    [
      # and then back again
      [1, :drawing_phase, 1],
      [1, :drawing_phase, 2],
    ].each do |test|
      expect([@duel.current_player_number, @duel.phase, @duel.priority_player_number]).to eq(test)
      expect(@duel.turn).to eq(2), "at turn #{test}"
      @phases.pass!
    end

  end

  it "passing order works as expected when the second player starts first" do
    @duel.priority_player_number = 2
    @duel.first_player_number = 2
    @duel.current_player_number = 2

    [
      [2, :drawing_phase, 2],
      [2, :drawing_phase, 1],
      [1, :drawing_phase, 1],
      [1, :drawing_phase, 2],
    ].each do |test|
      expect([@duel.current_player_number, @duel.phase, @duel.priority_player_number]).to eq(test)
      expect(@duel.turn).to eq(1), "at turn #{test}"
      @phases.pass!
    end

    [
      # and then back again
      [2, :drawing_phase, 2],
      [2, :drawing_phase, 1],
    ].each do |test|
      expect([@duel.current_player_number, @duel.phase, @duel.priority_player_number]).to eq(test)
      expect(@duel.turn).to eq(2), "at turn #{test}"
      @phases.pass!
    end
  end

  context "#pass_until_next_turn" do
    before :each do
      expect(@duel.current_player).to eq(@duel.player1)
    end

    it "passes back to player 1" do
      pass_until_next_turn
      expect(@duel.current_player).to eq(@duel.player1)
    end

    it "gives priority to player 1" do
      pass_until_next_turn
      expect(@duel.priority_player).to eq(@duel.player1)
    end

    it "increments the turn number" do
      expect(@duel.turn).to eq(1)
      pass_until_next_turn
      expect(@duel.turn).to eq(2)
    end
  end

  context "#pass_until_next_player" do
    before :each do
      expect(@duel.current_player).to eq(@duel.player1)
    end

    it "passes to player 2" do
      pass_until_next_player
      expect(@duel.current_player).to eq(@duel.player2)
    end

    it "gives priority to player 2" do
      pass_until_next_player
      expect(@duel.priority_player).to eq(@duel.player2)
    end

    it "does not increment the turn number" do
      expect(@duel.turn).to eq(1)
      pass_until_next_player
      expect(@duel.turn).to eq(1)
    end

    context "#pass_until_current_player_has_priority" do
      before :each do
        pass_until_next_player
      end

      it "gives priority to player 2" do
        pass_until_next_player
        expect(@duel.priority_player).to eq(@duel.player1)
      end
    end
  end

end
