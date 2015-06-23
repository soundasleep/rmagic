module SetupGame

  # load a basic game state
  def setup

    player1 = Player.create!(name: "Player 1", life: 20, is_ai: false)
    player2 = Player.create!(name: "Player 2", life: 20, is_ai: false)

    @duel = Duel.create!(player1: player1, player2: player2)

    10.times do
      creature = Card.create!( metaverse_id: 1, turn_played: 0 )
      Deck.create!( card: creature, player: player1 )
    end
    10.times do
      creature = Card.create!( metaverse_id: 1, turn_played: 0 )
      Deck.create!( card: creature, player: player2 )
    end

    3.times do
      forest = Card.create!( metaverse_id: 2, turn_played: 0 )
      Battlefield.create!( card: forest, player: player1 )
    end
    3.times do
      forest = Card.create!( metaverse_id: 2, turn_played: 0 )
      Battlefield.create!( card: forest, player: player2 )
    end

    @duel.save!

  end

  def create_creatures
    3.times do
      creature = Card.create!( metaverse_id: 1, turn_played: 0 )
      @duel.player1.battlefield.create! card: creature
    end
    2.times do
      creature = Card.create!( metaverse_id: 1, turn_played: 0 )
      @duel.player2.battlefield.create! card: creature
    end
  end

  def create_hand_cards(metaverse_id)
    1.times do
      card = Card.create!( metaverse_id: metaverse_id, turn_played: 0 )
      @duel.player1.hand.create card: card
    end
    1.times do
      card = Card.create!( metaverse_id: metaverse_id, turn_played: 0 )
      @duel.player2.hand.create card: card
    end
  end

  def create_battlefield_cards(metaverse_id)
    1.times do
      card = Card.create!( metaverse_id: metaverse_id, turn_played: 0 )
      @duel.player1.battlefield.create! card: card
    end
    1.times do
      card = Card.create!( metaverse_id: metaverse_id, turn_played: 0 )
      @duel.player2.battlefield.create! card: card
    end
  end

  def create_ability_creatures
    create_battlefield_cards(3)
  end

  def our_creatures
    @duel.player1.battlefield.creatures.map{ |b| b.card }
  end

  def available_attackers
    game_engine.available_attackers(@duel.current_player)
  end

  def available_actions
    game_engine.available_actions(@duel.player1)
  end

  def actions(card, action)
    @duel.action_logs.where card_action: action, card: card
  end

  def declaring_actions(hand)
    actions(hand.card, "declare")
  end

  def defending_actions(hand)
    actions(hand.card, "defend")
  end

  def defended_actions(hand)
    actions(hand.card, "defended")
  end

  def attacking_actions(hand)
    actions(hand.card, "attack")
  end

  def graveyard_actions(card)
    actions(card, "graveyard")
  end

  def available_ability_actions(index)
    available_actions[:ability].select { |action| action[:action] == index }
  end

  def available_play_actions(index)
    available_actions[:play].select { |action| action[:action] == index }
  end

  def game_engine
    @game_engine ||= GameEngine.new(@duel)
  end

  def tap_all_lands
    # tap all battlefield lands
    @duel.player1.battlefield.lands.each do |b|
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

