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

    redirect_to duel_player_path duel, duel.player1
  end

  def show
    respond_to do |format|
      format.json { render :json => DuelPresenter.new(duel).to_json }
    end
  end

  def action_log
    respond_to do |format|
      format.json { render :json => DuelPresenter.new(duel).action_logs_json }
    end
  end

  def stack
    respond_to do |format|
      format.json { render :json => DuelPresenter.new(duel).stack_json }
    end
  end

  private
    def duel
      Duel.find(params[:duel_id] || params[:id])
    end

end
