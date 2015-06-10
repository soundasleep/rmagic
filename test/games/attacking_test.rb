require_relative "game_test"

class AttackingTest < GameTest

  def setup
    super

    create_creatures

    @duel.phase_number = Duel.attacking_phase
    @duel.save!
  end

  test "at the start of a duel, we have no declared attackers" do
    assert_equal [], @duel.declared_attackers
  end

  def our_creatures
    @duel.player1.battlefield.select{ |b| b.entity.find_card!.is_creature? }.map{ |b| b.entity }
  end

  def available_attackers
    game_engine.available_attackers(@duel.player1)
  end

  test "we can declare three attackers on our turn" do
    assert_equal our_creatures, available_attackers.map{ |b| b.entity }
  end

  test "we can't declare any attackers when its not our turn" do
    @duel.current_player_number = 2
    @duel.save!

    available_attackers.map{ |b| b.entity }.each do |e|
      refute_includes our_creatures, e
    end
  end

  test "after we declare three attackers, we can declare two defenders (from player 2)" do
    game_engine.declare_attackers available_attackers
    game_engine.pass

    defends = game_engine.available_actions(@duel.player2)[:defend]

    assert_equal 2, defends.to_a.uniq{ |d| d[:source] }.count
  end

  test "defenders have an entity and a target" do
    game_engine.declare_attackers available_attackers
    game_engine.pass

    defends = game_engine.available_actions(@duel.player2)[:defend]
    defends.each do |d|
      assert_not_nil d[:source], "#{d} had no :source"
      assert_not_nil d[:target], "#{d} had no :target"
      assert_not_nil d[:source].entity, "#{d} had no :source.entity"
      assert_not_nil d[:target].entity, "#{d} had no :target.entity"
    end
  end

  test "each defender can defend one attacker" do
    game_engine.declare_attackers available_attackers
    game_engine.pass

    defends = game_engine.available_actions(@duel.player2)[:defend]

    assert_equal (2 * 3), defends.count
  end

  test "each defender can defend one attacker if only one attacks" do
    game_engine.declare_attackers [available_attackers.first]
    game_engine.pass

    defends = game_engine.available_actions(@duel.player2)[:defend]

    assert_equal 2, defends.count
  end

  test "declared attackers are available through the duel" do
    game_engine.declare_attackers available_attackers
    assert_equal available_attackers.map{ |a| a.entity }, @duel.declared_attackers.map{ |a| a.entity }
  end

  test "after declaring attackers, when we get to the next turn the attackers will be cleared" do
    game_engine.declare_attackers available_attackers
    assert_not_equal [], @duel.declared_attackers

    pass_until_next_turn

    assert_equal [], @duel.declared_attackers
  end

  test "after declaring attackers, when we get to the next player the attackers will be cleared" do
    game_engine.declare_attackers available_attackers
    assert_not_equal [], @duel.declared_attackers

    pass_until_next_player

    assert_equal [], @duel.declared_attackers
  end

  def declaring_actions(card)
    Action.where(duel: @duel, entity_action: "declare", entity: card.entity)
  end

  def defending_actions(card)
    Action.where(duel: @duel, entity_action: "defend", entity: card.entity)
  end

  def attacking_actions(card)
    Action.where(duel: @duel, entity_action: "attack", entity: card.entity)
  end

  test "declaring an attacker creates an action" do
    card = available_attackers.first
    assert_equal 0, declaring_actions(card).count

    game_engine.declare_attackers [card]

    assert_equal 1, declaring_actions(card).count
  end

  test "declared attackers do not persist into the next turn" do
    card = available_attackers.first
    assert_equal 0, @duel.declared_attackers.count

    game_engine.declare_attackers [card]

    assert_equal 1, @duel.declared_attackers.count

    pass_until_next_player
    assert_equal 0, @duel.declared_attackers.count
  end

  test "an attacker stores which player is attacking" do
    card = available_attackers.first
    game_engine.declare_attackers [card]
    assert_equal @duel.player1, @duel.declared_attackers.first.player
  end

  test "an attacker stores which player its attacking" do
    card = available_attackers.first
    game_engine.declare_attackers [card]
    assert_equal @duel.player2, @duel.declared_attackers.first.target_player
  end

  test "if no defenders are declared, then attacks hit the player" do
    assert_equal 20, @duel.player2.life

    card = available_attackers.first
    game_engine.declare_attackers [card]
    game_engine.pass

    pass_until_next_turn

    assert_equal (20 - card.entity.find_card!.power), @duel.player2.life
  end

  test "a player can't defend when they're still attacking" do
    card = available_attackers.first
    game_engine.declare_attackers [card]

    assert_equal [], game_engine.available_actions(@duel.player2)[:defend]
    game_engine.pass

    # but the next player can
    assert_not_equal [], game_engine.available_actions(@duel.player2)[:defend]
  end

  test "a declared defender does not come up as another available defend option" do
    card = available_attackers.first
    game_engine.declare_attackers [card]
    game_engine.pass

    defends = game_engine.available_actions(@duel.player2)[:defend]
    defender = defends.first
    game_engine.declare_defender defender

    game_engine.available_actions(@duel.player2)[:defend].each do |defend|
      refute_equal defend[:source], defender[:source]
    end
  end

  test "a defender can be declared and blocks damage" do
    card = available_attackers.first
    game_engine.declare_attackers [card]
    game_engine.pass

    defends = game_engine.available_actions(@duel.player2)[:defend]

    game_engine.declare_defender defends.first

    pass_until_next_turn

    assert_equal 20, @duel.player2.life
  end

  test "a declared defender creates an action" do
    card = available_attackers.first
    game_engine.declare_attackers [card]
    game_engine.pass

    defends = game_engine.available_actions(@duel.player2)[:defend]
    card = defends.first

    assert_equal 0, defending_actions(card[:source]).count

    game_engine.declare_defender card
    assert_equal 1, defending_actions(card[:source]).count
  end

  test "a defender can be declared and referenced later" do
    card = available_attackers.first
    game_engine.declare_attackers [card]
    game_engine.pass

    defends = game_engine.available_actions(@duel.player2)[:defend]

    assert_equal 0, @duel.declared_defenders.count
    game_engine.declare_defender defends.first
    assert_equal 1, @duel.declared_defenders.count
  end

  test "declared defenders do not persist into the next turn" do
    card = available_attackers.first
    game_engine.declare_attackers [card]
    game_engine.pass

    defends = game_engine.available_actions(@duel.player2)[:defend]

    assert_equal 0, @duel.declared_defenders.count
    game_engine.declare_defender defends.first
    assert_equal 1, @duel.declared_defenders.count

    pass_until_next_player
    assert_equal 0, @duel.declared_defenders.count
  end

  test "attacking actions are created when there are defenders and the attack resolves" do
    card = available_attackers.first
    game_engine.declare_attackers [card]
    game_engine.pass

    defends = game_engine.available_actions(@duel.player2)[:defend]
    game_engine.declare_defender defends.first

    assert_equal 0, attacking_actions(card).count

    pass_until_next_turn

    assert_equal 1, attacking_actions(card).count
  end

  test "attacking actions references the attacked defender" do
    card = available_attackers.first
    game_engine.declare_attackers [card]
    game_engine.pass

    defends = game_engine.available_actions(@duel.player2)[:defend]
    game_engine.declare_defender defends.first

    assert_equal 0, attacking_actions(card).count

    pass_until_next_turn

    action = attacking_actions(card).first
    assert_equal defends.first[:source].entity, action.targets.first.entity
  end

  test "attacking actions include a reference to defending creatures after the attack resolves" do
    card = available_attackers.first
    game_engine.declare_attackers [card]
    game_engine.pass

    defends = game_engine.available_actions(@duel.player2)[:defend]
    game_engine.declare_defender defends.first

    pass_until_next_turn

    action = attacking_actions(card).first
    assert_equal defends.first[:target].entity, action.entity
  end

  test "attacking actions are created when there are no defenders and the attack resolves" do
    card = available_attackers.first
    game_engine.declare_attackers [card]
    game_engine.pass

    assert_equal 0, attacking_actions(card).count

    pass_until_next_turn

    assert_equal 1, attacking_actions(card).count
  end

end
