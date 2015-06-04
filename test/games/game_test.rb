require 'test_helper'

class GameTest < ActiveSupport::TestCase

  # load a basic game state
  def setup

    player1 = Player.create!(name: "Player", life: 20, is_ai: false)
    player2 = Player.create!(name: "Player", life: 20, is_ai: false)

    @duel = Duel.create!(player1: player1, player2: player2)

    entity = Entity.create!( metaverse_id: 1 )

    10.times { Deck.create!( entity: entity, player: player1 ) }
    10.times { Deck.create!( entity: entity, player: player2 ) }

  end

end
