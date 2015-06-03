require 'test_helper'

class DuelTest < ActiveSupport::TestCase
  test "priority passes" do
    @duel = Duel.new({ priority_player: 1 })
    @duel.pass
    assert_equal 2, @duel.priority_player
  end

  test "priority returns after two passes" do
    @duel = Duel.new({ priority_player: 1 })
    @duel.pass
    @duel.pass
    assert_equal 1, @duel.priority_player
  end

  test "passing updates the phase" do
    @duel = Duel.new({ priority_player: 1, phase: 1 })
    @duel.pass
    assert_equal 1, @duel.phase
    @duel.pass
    assert_equal 2, @duel.phase
  end

  test "priority returns if the second player is first to start" do
    @duel = Duel.new({ priority_player: 1, phase: 1, first_player: 2, current_player: 2 })
    @duel.pass
    assert_equal 2, @duel.priority_player
    assert_equal 2, @duel.phase
    @duel.pass
    assert_equal 2, @duel.phase
  end

end
