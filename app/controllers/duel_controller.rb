class DuelController < ApplicationController
  def new
    # create a temporary duel to display
    @player1 = Player.new({ name: "Jevon", life: 20, is_ai: false })
    @player2 = Player.new({ name: "AI", life: 15, is_ai: true })

    @duel = Duel.new({ player1: @player1, player2: @player2, current_player: 1, phase: 1, priority_player: 1 })

    @entity1 = Entity.new({ metaverse_id: 1 })

    @deck1 = Deck.new({ entity: @entity1, player: @player1 })
    @deck2 = Deck.new({ entity: @entity1, player: @player1 })
    @deck3 = Deck.new({ entity: @entity1, player: @player2 })

    @hand1 = Hand.new({ entity: @entity1, player: @player1 })
    @hand2 = Hand.new({ entity: @entity1, player: @player2 })

    @battlefield1 = Battlefield.new({ entity: @entity1, player: @player1 })
    @battlefield2 = Battlefield.new({ entity: @entity1, player: @player2 })

    @player1.save
    @player2.save
    @duel.save
    @deck1.save
    @deck2.save
    @deck3.save
    @hand1.save
    @hand2.save
    @battlefield1.save
    @battlefield2.save

    @action1 = Action.new({ entity: @entity1, entity_action: 0, player: @player2, duel: @duel })
    @action_target1 = ActionTarget.new({ entity: @entity1, action: @action1, damage: 1 })

    @action1.save
    @action_target1.save

    redirect_to duel_path @duel
  end

  def show
    @duel = Duel.find(params[:id])
  end

  def pass
    @duel = Duel.find(params[:id])
    @duel.pass
    @duel.save!
    redirect_to duel_path @duel
  end
end
