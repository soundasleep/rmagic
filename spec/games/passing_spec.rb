require_relative "setup_game"

RSpec.describe "Passing" do
  before :each do
    setup
  end

  it "starting a new turn draws a card" do
    expect(@duel.total_phases).to eq(4)

    [
      [1, 1, 1],
      [1, 1, 2],
      [1, 2, 1],
      [1, 2, 2],
      [1, 3, 1],
      [1, 3, 2],
      [1, 4, 1],
      [1, 4, 2],
      [2, 1, 2],
      [2, 1, 1],
      [2, 2, 2],
      [2, 2, 1],
      [2, 3, 2],
      [2, 3, 1],
      [2, 4, 2],
      [2, 4, 1],
    ].each do |test|
      expect([@duel.current_player_number, @duel.phase_number, @duel.priority_player_number]).to eq(test)
      expect(@duel.turn).to eq(1), "at turn #{test}"
      @duel.pass
    end

    [
      # and then back again
      [1, 1, 1],
      [1, 1, 2],
    ].each do |test|
      expect([@duel.current_player_number, @duel.phase_number, @duel.priority_player_number]).to eq(test)
      expect(@duel.turn).to eq(2), "at turn #{test}"
      @duel.pass
    end

  end

  it "passing order works as expected when the second player starts first" do
    @duel.priority_player_number = 2
    @duel.first_player_number = 2
    @duel.current_player_number = 2

    expect(@duel.total_phases).to eq(4)

    [
      [2, 1, 2],
      [2, 1, 1],
      [2, 2, 2],
      [2, 2, 1],
      [2, 3, 2],
      [2, 3, 1],
      [2, 4, 2],
      [2, 4, 1],
      [1, 1, 1],
      [1, 1, 2],
      [1, 2, 1],
      [1, 2, 2],
      [1, 3, 1],
      [1, 3, 2],
      [1, 4, 1],
      [1, 4, 2],
    ].each do |test|
      expect([@duel.current_player_number, @duel.phase_number, @duel.priority_player_number]).to eq(test)
      expect(@duel.turn).to eq(1), "at turn #{test}"
      @duel.pass
    end

    [
      # and then back again
      [2, 1, 2],
      [2, 1, 1],
    ].each do |test|
      expect([@duel.current_player_number, @duel.phase_number, @duel.priority_player_number]).to eq(test)
      expect(@duel.turn).to eq(2), "at turn #{test}"
      @duel.pass
    end
  end

end
