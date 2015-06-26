class DuelController < ApplicationController
  before_filter :authenticate

  def create
    player1 = current_user.players.create! name: current_user.name, life: 20, is_ai: false
    player2 = Player.create! name: "AI", life: 20, is_ai: true

    @duel = Duel.create! player1: player1, player2: player2

    # create deck
    deck1 = PremadeDeck.find(params[:deck1])
    deck2 = PremadeDeck.find(params[:deck2])

    deck1.cards.each_with_index do |c, i|
      create_order_card player1.deck, c.metaverse_id, i
    end
    deck2.cards.each_with_index do |c, i|
      create_order_card player2.deck, c.metaverse_id, i
    end

    duel.save!

    # execute the first phase of the game
    duel.phase.setup_phase(game_engine)

    redirect_to duel_path duel
  end

  def duel
    # TODO check that we can actually view/interact with this duel
    @duel ||= Duel.find(params[:id])
  end

  def show
    @duel = duel
  end

  def pass
    PhaseManager.new(game_engine).pass!
    redirect_to duel_path duel
  end

  def play
    game_engine.card_action PossiblePlay.new(
      source: Hand.find(params[:hand]),
      key: params[:key],
      target: find_target
    )
    redirect_to duel_path duel
  end

  def ability
    game_engine.card_action PossibleAbility.new(
      source: Battlefield.find(params[:battlefield]),
      key: params[:key],
      target: find_target
    )
    redirect_to duel_path duel
  end

  def defend
    source = Battlefield.find(params[:source])
    target = DeclaredAttacker.find(params[:target])
    game_engine.declare_defender PossibleDefender.new(
      source: source,
      target: target
    )
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
  helper_method :get_target_type

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

  def create_order_card(zone, metaverse_id, order)
    card = Card.create!( metaverse_id: metaverse_id, turn_played: 0 )
    zone.create! card: card, order: order
  end

  def find_target
    case params[:target_type]
      when "player"
        Player.find(params[:target])
      when "battlefield"
        Battlefield.find(params[:target])
      when "none"
        nil
      else
        fail "Unknown target type '#{params[:target_type]}'"
    end
  end

  def get_target_type(target)
    return "none" if target == nil
    case target.class.name
      when "Player"
        "player"
      when "Battlefield"
        "battlefield"
      else
        fail "Unknown target type '#{target.class.name}'"
    end
  end

end
