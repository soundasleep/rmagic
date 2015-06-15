module SetupGame

  # load a basic game state
  def setup

    player1 = Player.create!(name: "Player 1", life: 20, is_ai: false)
    player2 = Player.create!(name: "Player 2", life: 20, is_ai: false)

    @duel = Duel.create!(player1: player1, player2: player2)

    10.times do
      creature = Entity.create!( metaverse_id: 1, turn_played: 0 )
      Deck.create!( entity: creature, player: player1 )
    end
    10.times do
      creature = Entity.create!( metaverse_id: 1, turn_played: 0 )
      Deck.create!( entity: creature, player: player2 )
    end

    3.times do
      forest = Entity.create!( metaverse_id: 2, turn_played: 0 )
      Battlefield.create!( entity: forest, player: player1 )
    end
    3.times do
      forest = Entity.create!( metaverse_id: 2, turn_played: 0 )
      Battlefield.create!( entity: forest, player: player2 )
    end

    @duel.save!

  end

  def create_creatures
    3.times do
      creature = Entity.create!( metaverse_id: 1, turn_played: 0 )
      Battlefield.create!( entity: creature, player: @duel.player1 )
    end
    2.times do
      creature = Entity.create!( metaverse_id: 1, turn_played: 0 )
      Battlefield.create!( entity: creature, player: @duel.player2 )
    end
  end

  def create_ability_creatures
    1.times do
      creature = Entity.create!( metaverse_id: 3, turn_played: 0 )
      Battlefield.create!( entity: creature, player: @duel.player1 )
    end
    1.times do
      creature = Entity.create!( metaverse_id: 3, turn_played: 0 )
      Battlefield.create!( entity: creature, player: @duel.player2 )
    end
  end

  def our_creatures
    @duel.player1.battlefield.select{ |b| b.entity.find_card.is_creature? }.map{ |b| b.entity }
  end

  def available_attackers
    game_engine.available_attackers(@duel.current_player)
  end

  def available_actions
    game_engine.available_actions(@duel.player1)
  end

  def actions(entity, action)
    Action.where(duel: @duel, entity_action: action, entity: entity)
  end

  def declaring_actions(card)
    actions(card.entity, "declare")
  end

  def defending_actions(card)
    actions(card.entity, "defend")
  end

  def defended_actions(card)
    actions(card.entity, "defended")
  end

  def attacking_actions(card)
    actions(card.entity, "attack")
  end

  def graveyard_actions(entity)
    actions(entity, "graveyard")
  end

  def game_engine
    GameEngine.new(@duel)
  end

  def tap_all_lands
    # tap all battlefield lands
    @duel.player1.battlefield.select { |b| b.entity.find_card.is_land? }.each do |b|
      game_engine.card_action(b, "tap")
    end
  end

  def pass_until_next_turn
    t = @duel.turn
    i = 0

    while @duel.turn == t do
      i += 1
      assert_operator i, :<, 100, "it took too long to get to the next turn"
      game_engine.pass
    end
  end

  def pass_until_next_player
    c = @duel.current_player
    i = 0

    while @duel.current_player == c do
      i += 1
      assert_operator i, :<, 100, "it took too long to get to the next turn"
      game_engine.pass
    end
  end

  def pass_until_current_player_has_priority
    i = 0

    while @duel.priority_player != @duel.player1 do
      i += 1
      assert_operator i, :<, 100, "it took too long to get to the next priority"
      game_engine.pass
    end
  end

end

RSpec.configure do |c|
  c.include SetupGame
end

