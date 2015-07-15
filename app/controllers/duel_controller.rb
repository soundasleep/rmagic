class DuelController < ApplicationController
  before_filter :authenticate

  def create
    # Create an AI player
    ai = User.create! name: "AI", is_ai: true

    deck1 = PremadeDeck.find(params[:deck1])
    deck2 = PremadeDeck.find(params[:deck2])

    # Call the service to create the duel
    duel = CreateGame.new(user1: current_user, user2: ai, deck1: deck1, deck2: deck2).call

    # Start the game
    StartGame.new(duel: duel).call

    redirect_to duel_path duel
  end

  def show
    @duel = duel
  end

  # TODO maybe refactor into resources e.g.
  # POST /duel/123/turn/create/[source]/[key]/[target]?
  # POST /duel/123/turn/play/[source]/[key]/[target]?
  # POST /duel/123/play/[source]/[key]/[target]?
  # e.g. GET /duel/123/player/1/battlefield.json
  #
  # POST /duel/123/player/1/hand/123/play?key="do something"
  # - this maps nicely to getting child resources through .json
  def play
    action = PlayAction.new(
      source: Hand.find(params[:hand]),
      key: params[:key],
      target: find_target
    )
    action.do(duel)
    redirect_to duel_path duel
  end

  def ability
    action = AbilityAction.new(
      source: Battlefield.find(params[:battlefield]),
      key: params[:key],
      target: find_target
    )
    action.do(duel)
    redirect_to duel_path duel
  end

  def defend
    source = Battlefield.find(params[:source])
    target = DeclaredAttacker.find(params[:target])
    defender = DefenderAction.new(
      source: source,
      target: target
    )
    defender.declare(duel)
    redirect_to duel_path duel
  end

  def declare_attackers
    if params[:attacker]
      attackers = Battlefield.find(params[:attacker])
      DeclareAttackers.new(duel: duel, zone_cards: attackers).call
    end
    duel.save!    # TODO remove
    pass
  end

  def game_action
    action = GameAction.new(
      player: duel.player1,
      key: params[:key]
    )
    action.do(duel)
    redirect_to duel_path duel
  end

  helper_method :playable_cards, :ability_cards, :defendable_cards,
      :available_attackers, :game_actions
  helper_method :get_target_type

  def playable_cards
    action_finder.playable_cards duel.player1
  end

  def ability_cards
    action_finder.ability_cards duel.player1
  end

  def defendable_cards
    action_finder.defendable_cards duel.player1
  end

  def available_attackers
    action_finder.available_attackers duel.player1
  end

  def game_actions
    action_finder.game_actions duel.player1
  end

  private

    def duel
      # TODO check permissions that we can actually view/interact with this duel
      @duel ||= Duel.find(params[:id])
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

    def action_finder
      @action_finder ||= ActionFinder.new(duel)
    end

end
