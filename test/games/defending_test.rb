require_relative "game_test"

class DefendingTest < GameTest

  def setup
    super

    create_creatures

    @duel.phase_number = Duel.attacking_phase
    @duel.save!

    @card = available_attackers.first
    game_engine.declare_attackers [@card]

    game_engine.pass
  end

  test "each defender can defend one attacker if only one attacks" do
    defends = game_engine.available_actions(@duel.player2)[:defend]

    assert_equal 2, defends.count
  end

  test "an attacker stores which player is attacking" do
    assert_equal @duel.player1, @duel.declared_attackers.first.player
  end

  test "an attacker stores which player its attacking" do
    assert_equal @duel.player2, @duel.declared_attackers.first.target_player
  end

  test "a declared defender does not come up as another available defend option" do
    defends = game_engine.available_actions(@duel.player2)[:defend]
    defender = defends.first
    game_engine.declare_defender defender

    game_engine.available_actions(@duel.player2)[:defend].each do |defend|
      refute_equal defend[:source], defender[:source]
    end
  end

  test "a defender can be declared and blocks damage" do
    defends = game_engine.available_actions(@duel.player2)[:defend]

    game_engine.declare_defender defends.first

    pass_until_next_turn

    assert_equal 20, @duel.player2.life
  end

  test "a declared defender creates an action" do
    defends = game_engine.available_actions(@duel.player2)[:defend]
    card = defends.first

    assert_equal 0, defending_actions(card[:source]).count

    game_engine.declare_defender card
    assert_equal 1, defending_actions(card[:source]).count
  end

  test "a defender can be declared and referenced later" do
    defends = game_engine.available_actions(@duel.player2)[:defend]

    assert_equal 0, @duel.declared_defenders.count
    game_engine.declare_defender defends.first
    assert_equal 1, @duel.declared_defenders.count
  end

  test "declared defenders do not persist into the next turn" do
    defends = game_engine.available_actions(@duel.player2)[:defend]

    assert_equal 0, @duel.declared_defenders.count
    game_engine.declare_defender defends.first
    assert_equal 1, @duel.declared_defenders.count

    pass_until_next_player
    assert_equal 0, @duel.declared_defenders.count
  end

  test "attacking actions are created when there are defenders and the attack resolves" do
    defends = game_engine.available_actions(@duel.player2)[:defend]
    game_engine.declare_defender defends.first

    assert_equal 0, attacking_actions(@card).count

    pass_until_next_turn

    assert_equal 1, attacking_actions(@card).count
  end

  test "attacking actions references the attacked defender" do
    defends = game_engine.available_actions(@duel.player2)[:defend]
    game_engine.declare_defender defends.first

    assert_equal 0, attacking_actions(@card).count

    pass_until_next_turn

    action = attacking_actions(@card).first
    assert_equal defends.first[:source].entity, action.targets.first.entity
  end

  test "attacking actions include a reference to defending creatures after the attack resolves" do
    defends = game_engine.available_actions(@duel.player2)[:defend]
    game_engine.declare_defender defends.first

    pass_until_next_turn

    action = attacking_actions(@card).first
    assert_equal defends.first[:target].entity, action.entity
  end

  test "attacking actions are created when there are no defenders and the attack resolves" do
    assert_equal 0, attacking_actions(@card).count

    pass_until_next_turn

    assert_equal 1, attacking_actions(@card).count
  end

end
