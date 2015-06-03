class DuelController < ApplicationController
  def show
    # create a temporary duel to display
    @player1 = Player.new({ name: "Jevon", life: 20, is_ai: false })
    @player2 = Player.new({ name: "AI", life: 15, is_ai: true })

    @duel = Duel.new({ player1: @player1, player2: @player2, current_player: 1, phase: 1 })

    @entity1 = Entity.new({ metaverse_id: 1 })

    @deck1 = Deck.new({ entity: @entity1, player: @player1 })
    @deck2 = Deck.new({ entity: @entity1, player: @player1 })
    @deck3 = Deck.new({ entity: @entity1, player: @player2 })

    @hand1 = Hand.new({ entity: @entity1, player: @player1 })
    @hand2 = Hand.new({ entity: @entity1, player: @player2 })

    @battlefield1 = Battlefield.new({ entity: @entity1, player: @player1 })

    @player1.save
    @player2.save
    @duel.save
    @deck1.save
    @deck2.save
    @deck3.save
    @hand1.save
    @hand2.save
    @battlefield1.save

  end
end
