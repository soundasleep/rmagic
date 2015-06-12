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
      [1, "drawing_phase", 1],
      [1, "drawing_phase", 2],
      [2, "drawing_phase", 2],
      [2, "drawing_phase", 1],
    ].each do |test|
      expect([@duel.current_player_number, @duel.phase_number, @duel.priority_player_number]).to eq(test)
      expect(@duel.turn).to eq(1), "at turn #{test}"
      @phases.pass!
    end

    [
      # and then back again
      [1, "drawing_phase", 1],
      [1, "drawing_phase", 2],
    ].each do |test|
      expect([@duel.current_player_number, @duel.phase_number, @duel.priority_player_number]).to eq(test)
      expect(@duel.turn).to eq(2), "at turn #{test}"
      @phases.pass!
    end

  end

  it "passing order works as expected when the second player starts first" do
    @duel.priority_player_number = 2
    @duel.first_player_number = 2
    @duel.current_player_number = 2

    [
      [2, "drawing_phase", 2],
      [2, "drawing_phase", 1],
      [1, "drawing_phase", 1],
      [1, "drawing_phase", 2],
    ].each do |test|
      expect([@duel.current_player_number, @duel.phase_number, @duel.priority_player_number]).to eq(test)
      expect(@duel.turn).to eq(1), "at turn #{test}"
      @phases.pass!
    end

    [
      # and then back again
      [2, "drawing_phase", 2],
      [2, "drawing_phase", 1],
    ].each do |test|
      expect([@duel.current_player_number, @duel.phase_number, @duel.priority_player_number]).to eq(test)
      expect(@duel.turn).to eq(2), "at turn #{test}"
      @phases.pass!
    end
  end

end
