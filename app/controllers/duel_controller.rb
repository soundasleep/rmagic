class DuelController < ApplicationController
  include ActionableController

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
    @player = duel.player1
  end

  # TODO maybe refactor into resources e.g.
  # POST /duel/123/turn/create/[source]/[key]/[target]?
  # POST /duel/123/turn/play/[source]/[key]/[target]?
  # POST /duel/123/play/[source]/[key]/[target]?
  # e.g. GET /duel/123/player/1/battlefield.json
  #
  # POST /duel/123/player/1/hand/123/play?key="do something"
  # - this maps nicely to getting child resources through .json
  def declare_attackers
    if params[:attacker]
      attackers = Battlefield.find(params[:attacker])
      DeclareAttackers.new(duel: duel, zone_cards: attackers).call
    end
    duel.save!    # TODO remove

    # and then pass
    action = GameAction.new(
      player: duel.player1,
      key: "pass"
    )
    action.do(duel)

    redirect_to duel_path duel
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

    def action_finder
      @action_finder ||= ActionFinder.new(duel)
    end

end
