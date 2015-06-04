require 'test_helper'

class DuelTest < ActiveSupport::TestCase

  test "passing order works as expected" do
    @duel = Duel.new({ first_player: 1, current_player: 1, phase: 1, priority_player: 1 })
    assert_equal 4, @duel.total_phases

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
      assert_equal test, [@duel.current_player, @duel.phase, @duel.priority_player]
      assert_equal 1, @duel.turn, "at turn #{test}"
      @duel.pass
    end

    [
      # and then back again
      [1, 1, 1],
      [1, 1, 2],
    ].each do |test|
      assert_equal test, [@duel.current_player, @duel.phase, @duel.priority_player]
      assert_equal 2, @duel.turn, "at turn #{test}"
      @duel.pass
    end
  end

  test "passing order works as expected when the second player starts first" do
    @duel = Duel.new({ first_player: 2, current_player: 2, phase: 1, priority_player: 2 })
    assert_equal 4, @duel.total_phases

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
      assert_equal test, [@duel.current_player, @duel.phase, @duel.priority_player]
      assert_equal 1, @duel.turn, "at turn #{test}"
      @duel.pass
    end

    [
      # and then back again
      [2, 1, 2],
      [2, 1, 1],
    ].each do |test|
      assert_equal test, [@duel.current_player, @duel.phase, @duel.priority_player]
      assert_equal 2, @duel.turn, "at turn #{test}"
      @duel.pass
    end
  end

end
