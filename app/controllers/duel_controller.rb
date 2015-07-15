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
    # TODO move this into duel/1/player/1/show?
    @player = duel.player1
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
