require_relative "game_test"

class DefendingGroupTest < GameTest

  def setup
    super

    create_creatures

    @duel.phase_number = Duel.attacking_phase
    @duel.save!

    @card = available_attackers.first
    game_engine.declare_attackers [@card]

    game_engine.pass

    defends = game_engine.available_actions(@duel.player2)[:defend]
    game_engine.declare_defender defends.first
    defends = game_engine.available_actions(@duel.player2)[:defend]
    game_engine.declare_defender defends.first
  end

  test "we can defend with two defenders" do
    pass_until_next_turn

    assert_equal 20, @duel.player2.life
  end

  test "we can referenced the declared group defenders" do
    assert_equal 2, game_engine.declared_defenders.length
  end

  test "overdefending will kill the single attacker" do
    pass_until_next_turn

    refute_includes @duel.player1.battlefield, @card
  end

  test "overdefending will put the attacker into the graveyard" do
    assert_equal [], @duel.player1.graveyard

    pass_until_next_turn

    refute_equal [], @duel.player1.graveyard
  end

  test "overdefending will create a graveyard action" do
    assert_equal 0, graveyard_actions(@card.entity).count

    pass_until_next_turn

    assert_equal 1, graveyard_actions(@card.entity).count
  end
end
