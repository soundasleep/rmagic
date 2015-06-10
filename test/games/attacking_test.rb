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

  test "a player can't defend when they're still attacking" do
    card = available_attackers.first
    game_engine.declare_attackers [card]

    assert_equal [], game_engine.available_actions(@duel.player2)[:defend]
    game_engine.pass

    # but the next player can
    assert_not_equal [], game_engine.available_actions(@duel.player2)[:defend]
  end

  test "if no defenders are declared, then attacks hit the player" do
    card = available_attackers.first
    game_engine.declare_attackers [card]

    assert_equal 20, @duel.player2.life
    game_engine.pass

    pass_until_next_turn

    assert_equal (20 - card.entity.find_card!.power), @duel.player2.life
  end

end
