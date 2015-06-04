require 'test_helper'

class DuelTest < ActiveSupport::TestCase
  def default_duel
    Duel.new({ priority_player: 1, phase: 1, first_player: 1, current_player: 1 })
  end

  test "priority passes" do
    @duel = default_duel
    @duel.pass
    assert_equal 2, @duel.priority_player
  end

  test "priority returns after two passes" do
    @duel = default_duel
    @duel.pass
    @duel.pass
    assert_equal 1, @duel.priority_player
  end

  test "passing updates the phase" do
    @duel = default_duel
    @duel.pass
    assert_equal 1, @duel.phase
    @duel.pass
    assert_equal 2, @duel.phase
  end

  test "passing at the last phase turns control to the second player within the same turn" do
    @duel = default_duel
    @duel.phase = @duel.total_phases
    @duel.priority_player = 2
    @duel.pass
    assert_equal 1, @duel.turn
    assert_equal 2, @duel.current_player
    assert_equal 2, @duel.priority_player   # the second player has priority
  end

  # # tests for when the 'first player' is set to 2

  test "second player priority passes" do
    @duel = default_duel
    @duel.first_player = 2
    @duel.current_player = 2
    @duel.priority_player = 2
    @duel.pass
    assert_equal 1, @duel.priority_player
    assert_equal 1, @duel.turn
    assert_equal 1, @duel.phase
  end

  test "second player priority returns after two passes" do
    @duel = default_duel
    @duel.first_player = 2
    @duel.current_player = 2
    @duel.priority_player = 2
    @duel.pass
    @duel.pass
    assert_equal 2, @duel.priority_player
  end

  test "second player passing updates the phase" do
    @duel = default_duel
    @duel.first_player = 2
    @duel.current_player = 2
    @duel.priority_player = 2
    @duel.pass
    assert_equal 1, @duel.phase
    @duel.pass
    assert_equal 2, @duel.phase
  end

  test "second player passing at the last phase turns control to the first player within the same turn" do
    @duel = default_duel
    @duel.first_player = 2
    @duel.current_player = 2
    @duel.phase = @duel.total_phases
    @duel.priority_player = 2
    @duel.pass
    assert_equal 1, @duel.turn
    assert_equal 2, @duel.current_player
    assert_equal 1, @duel.priority_player   # the first player has priority
  end

end
