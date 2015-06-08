require_relative "game_test"

class AttackingTest < GameTest

  def setup
    super

    create_creatures

    @duel.phase = Duel.attacking_phase
    @duel.save!
  end

  test "at the start of a duel, we have no declared attackers" do
    assert_equal [], @duel.declared_attackers
  end

  test "we can declare three attackers" do
    assert_equal @duel.player1.battlefield.select{ |b| b.entity.find_card!.is_creature? }.map{ |b| b.entity }, game_engine.available_attackers.map{ |b| b.entity }
  end

  test "after we declare three attackers, we can declare two defenders (from player 2)" do
    game_engine.declare_attackers game_engine.available_attackers
    game_engine.pass

    defends = game_engine.available_actions(@duel.player2)[:defend]

    assert_equal 2, defends.to_a.uniq{ |d| d[:entity] }.count
  end

  test "defenders have an entity and a target" do
    game_engine.declare_attackers game_engine.available_attackers
    game_engine.pass

    defends = game_engine.available_actions(@duel.player2)[:defend]
    defends.each do |d|
      assert_not_nil d[:entity], "#{d} had no :entity"
      assert_not_nil d[:target], "#{d} had no :target"
    end
  end

  test "each defender can defend one attacker" do
    game_engine.declare_attackers game_engine.available_attackers
    game_engine.pass

    defends = game_engine.available_actions(@duel.player2)[:defend]

    assert_equal (2 * 3), defends.count
  end

  test "each defender can defend one attacker if only one attacks" do
    game_engine.declare_attackers [game_engine.available_attackers.first]
    game_engine.pass

    defends = game_engine.available_actions(@duel.player2)[:defend]

    assert_equal 2, defends.count
  end

  test "declared attackers are available through the duel" do
    game_engine.declare_attackers game_engine.available_attackers
    assert_equal game_engine.available_attackers.map{ |a| a.entity }, @duel.declared_attackers.map{ |a| a.entity }
  end

  test "after declaring attackers, when we get to the next turn the attackers will be cleared" do
    game_engine.declare_attackers game_engine.available_attackers
    assert_not_equal [], @duel.declared_attackers

    pass_until_next_turn

    assert_equal [], @duel.declared_attackers
  end

  test "after declaring attackers, when we get to the next player the attackers will be cleared" do
    game_engine.declare_attackers game_engine.available_attackers
    assert_not_equal [], @duel.declared_attackers

    pass_until_next_player

    assert_equal [], @duel.declared_attackers
  end

end
