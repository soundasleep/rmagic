require 'test_helper'

class GameTest < ActiveSupport::TestCase

  # load a basic game state
  def setup

    player1 = Player.create!(name: "Player 1", life: 20, is_ai: false)
    player2 = Player.create!(name: "Player 2", life: 20, is_ai: false)

    @duel = Duel.create!(player1: player1, player2: player2)

    10.times do
      creature = Entity.create!( metaverse_id: 1 )
      Deck.create!( entity: creature, player: player1 )
    end
    10.times do
      creature = Entity.create!( metaverse_id: 1 )
      Deck.create!( entity: creature, player: player2 )
    end

    3.times do
      forest = Entity.create!( metaverse_id: 2 )
      Battlefield.create!( entity: forest, player: player1 )
    end
    3.times do
      forest = Entity.create!( metaverse_id: 2 )
      Battlefield.create!( entity: forest, player: player2 )
    end

    @duel.save!

  end

  def game_engine
    GameEngine.new(@duel)
  end

end
