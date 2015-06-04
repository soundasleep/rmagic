require 'test_helper'

class DuelTest < ActiveSupport::TestCase
  def default_duel
    Duel.new({ first_player: 1, current_player: 1, phase: 1, priority_player: 1 })
  end

  test "passing order works as expected" do
    @duel = default_duel
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
      # and then back again
      [1, 1, 1]
    ].each do |test|
      assert_equal test, [@duel.current_player, @duel.phase, @duel.priority_player]
      @duel.pass
    end
  end

end
