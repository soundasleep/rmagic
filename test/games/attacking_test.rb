require_relative "game_test"

class AttackingTest < GameTest

  def setup
    super

    @duel.phase = Duel.attacking_phase
    @duel.save!
  end

  test "we can declare three attackers" do
    assert_equal @duel.player1.battlefield.map{ |b| b.entity }, game_engine.available_attackers.map{ |b| b.entity }
  end

  test "after we declare three attackers, we can declare two defenders (from player 2)" do
    game_engine.declare_attackers game_engine.available_attackers
    game_engine.pass

    defends = game_engine.available_actions(:defend)

    assert_equal 2, defends.count
  end

  test "each defender can defend one attacker" do
    game_engine.declare_attackers game_engine.available_attackers
    game_engine.pass

    defends = game_engine.available_actions(:defend)

    assert_equal 3, defends.first.targets.length
    assert_equal 3, defends.second.targets.length
  end

end
