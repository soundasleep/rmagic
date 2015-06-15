class DuelController < ApplicationController
  def new
    # create a temporary duel to display
    @player1 = Player.create!(
     name: "Jevon",
     life: 20,
     is_ai: false
    )
    @player2 = Player.create!(
      name: "AI",
      life: 15,
      is_ai: true
    )

    @duel = Duel.create!( player1: @player1, player2: @player2 )

    10.times do
      creature = Entity.create!( metaverse_id: 1, turn_played: 0 )
      Deck.create!( entity: creature, player: @player1 )
    end
    10.times do
      creature = Entity.create!( metaverse_id: 1, turn_played: 0 )
      Deck.create!( entity: creature, player: @player2 )
    end

    1.times do
      creature = Entity.create!( metaverse_id: 1, turn_played: 0 )
      Battlefield.create!( entity: creature, player: @player1 )
    end
    1.times do
      creature = Entity.create!( metaverse_id: 1, turn_played: 0 )
      Battlefield.create!( entity: creature, player: @player2 )
    end

    1.times do
      creature = Entity.create!( metaverse_id: 3, turn_played: 0 )
      Battlefield.create!( entity: creature, player: @player1 )
    end
    1.times do
      creature = Entity.create!( metaverse_id: 3, turn_played: 0 )
      Battlefield.create!( entity: creature, player: @player2 )
    end

    3.times do
      forest = Entity.create!( metaverse_id: 2, turn_played: 0 )
      Battlefield.create!( entity: forest, player: @player1 )
    end
    3.times do
      forest = Entity.create!( metaverse_id: 2, turn_played: 0 )
      Battlefield.create!( entity: forest, player: @player2 )
    end

    1.times do
      creature = Entity.create!( metaverse_id: 1, turn_played: 0 )
      Hand.create!( entity: creature, player: @player1 )
    end
    1.times do
      creature = Entity.create!( metaverse_id: 1, turn_played: 0 )
      Hand.create!( entity: creature, player: @player2 )
    end
    1.times do
      forest = Entity.create!( metaverse_id: 2, turn_played: 0 )
      Hand.create!( entity: forest, player: @player1 )
    end
    1.times do
      forest = Entity.create!( metaverse_id: 2, turn_played: 0 )
      Hand.create!( entity: forest, player: @player2 )
    end

    @action1 = Action.create!( entity: @player2.battlefield.first.entity, entity_action: "attack", player: @player2, duel: @duel )
    @action_target1 = ActionTarget.create!( entity: @player1.battlefield.first.entity, action: @action1, damage: 1 )

    redirect_to duel_path @duel
  end

  def duel
    Duel.find(params[:id])
  end

  def show
    @duel = duel
  end

  def pass
    PhaseManager.new(game_engine).pass!
    redirect_to duel_path duel
  end

  def play
    hand = Hand.find(params[:hand])
    game_engine.card_action hand, params[:key]
    redirect_to duel_path duel
  end

  def ability
    battlefield = Battlefield.find(params[:battlefield])
    game_engine.card_action battlefield, params[:key]
    redirect_to duel_path duel
  end

  def defend
    source = Battlefield.find(params[:source])
    target = DeclaredAttacker.find(params[:target])
    game_engine.declare_defender({source: source, target: target})
    redirect_to duel_path duel
  end

  def declare_attackers
    attackers = Battlefield.find(params[:attacker])
    game_engine.declare_attackers attackers
    duel.pass
    duel.save!
    redirect_to duel_path duel
  end

  helper_method :available_actions, :available_attackers

  def available_actions
    game_engine.available_actions duel.player1
  end

  def available_attackers
    game_engine.available_attackers duel.player1
  end

  def game_engine
    GameEngine.new(duel)
  end

end
