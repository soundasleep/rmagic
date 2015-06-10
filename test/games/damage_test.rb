require_relative "game_test"

class DamageTest < GameTest

  def setup
    super
    create_creatures
  end

  def first_creature
    @duel.player1.battlefield.select{ |b| b.entity.find_card!.is_creature? }.first
  end

  test "creatures start off with no damage" do
    assert_equal 0, first_creature.entity.damage
  end

  test "no damage causes no effects" do
    card = first_creature
    card.entity.damage! 0

    pass_until_next_turn

    assert_includes @duel.player1.battlefield, card
  end

  test "damage causes cards to be removed" do
    card = first_creature
    assert_includes @duel.player1.battlefield, card
    card.entity.damage! 100
    game_engine.move_destroyed_creatures_to_graveyard
    refute_includes @duel.player1.battlefield, card
  end

  test "lots of damage causes cards to be removed at the next turn" do
    card = first_creature

    card.entity.damage! 100
    pass_until_next_turn

    refute_includes @duel.player1.battlefield, card
  end

  test "a card with too much damage has the destroyed flag" do
    card = first_creature
    card.entity.damage! 100
    assert card.entity.is_destroyed?
  end

  test "a card with no much damage does not have the destroyed flag" do
    card = first_creature
    card.entity.damage! 0
    refute card.entity.is_destroyed?
  end

  test "a card with one damage does not have the destroyed flag" do
    card = first_creature
    card.entity.damage! 1
    refute card.entity.is_destroyed?
  end

  test "a destroyed creature is moved into the graveyard" do
    card = first_creature
    refute_includes @duel.player1.graveyard.map { |b| b.entity }, card.entity

    card.entity.damage! 100
    pass_until_next_turn

    assert_includes @duel.player1.graveyard.map { |b| b.entity }, card.entity
  end

  test "actions are created when creatures are moved to the graveyard" do
    card = first_creature

    assert_equal 0, graveyard_actions(card.entity).count

    card.entity.damage! 100
    pass_until_next_turn

    assert_equal 1, graveyard_actions(card.entity).count
  end

  test "temporary damage does not cause a card to be removed" do
    card = first_creature
    assert_not_equal 1, card.entity.find_card!.toughness
    card.entity.damage! 1

    pass_until_next_turn

    assert_includes @duel.player1.battlefield, card
  end

  test "temporary damage is not removed until the next players turn" do
    card = first_creature
    assert_not_equal 1, card.entity.find_card!.toughness
    card.entity.damage! 1

    game_engine.pass
    assert_equal 1, card.entity.damage
  end

  test "temporary damage is removed at the start of the next players turn" do
    card = first_creature
    assert_not_equal 1, card.entity.find_card!.toughness
    card.entity.damage! 1

    pass_until_next_turn

    card.entity.reload
    assert_equal 0, card.entity.damage
  end

end
