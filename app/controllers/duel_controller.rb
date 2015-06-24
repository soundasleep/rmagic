class DuelController < ApplicationController
  def create
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
      create_card @player1.deck, 1
    end
    10.times do
      create_card @player2.deck, 1
    end

    create_card @player1.battlefield, 1
    create_card @player1.battlefield, 1

    create_card @player1.battlefield, 3
    create_card @player2.battlefield, 3

    3.times do
      create_card @player1.battlefield, 2
    end
    3.times do
      create_card @player2.battlefield, 2
    end

    create_card @player1.hand, 1
    create_card @player2.hand, 1

    create_card @player1.hand, 2
    create_card @player2.hand, 2

    create_card @player1.hand, 4
    create_card @player2.hand, 4

    create_card @player1.hand, 5
    create_card @player2.hand, 5

    @action1 = ActionLog.create!( card: @player2.battlefield.first.card, card_action: "attack", player: @player2, duel: @duel )
    @action_target1 = ActionLogTarget.create!( card: @player1.battlefield.first.card, action_log: @action1, damage: 1 )

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
    target = nil
    target = Battlefield.find(params[:target]) if params[:target]
    game_engine.card_action hand, params[:key], target
    redirect_to duel_path duel
  end

  def ability
    battlefield = Battlefield.find(params[:battlefield])
    target = nil
    target = Battlefield.find(params[:target]) if params[:target]
    game_engine.card_action battlefield, params[:key], target
    redirect_to duel_path duel
  end

  def defend
    source = Battlefield.find(params[:source])
    target = DeclaredAttacker.find(params[:target])
    game_engine.declare_defender({source: source, target: target})
    redirect_to duel_path duel
  end

  def declare_attackers
    if params[:attacker]
      attackers = Battlefield.find(params[:attacker])
      game_engine.declare_attackers attackers
    end
    game_engine.pass
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

  private

  def create_card(zone, metaverse_id)
    card = Card.create!( metaverse_id: metaverse_id, turn_played: 0 )
    zone.create! card: card
  end

end
