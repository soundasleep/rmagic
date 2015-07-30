class PlayerController < ApplicationController
  include ActionableController

  before_filter :authenticate

  def show
    @duel = duel
    @player = player

    if !@duel.players.include?(@player)
      fail "That player #{player} is not in the duel #{duel}"
    end

    respond_to do |format|
      format.html
      format.json { render :json => PlayerPresenter.new(player).to_json(context) }
    end
  end

  def actions
    respond_to do |format|
      format.json { render :json => PlayerPresenter.new(player).actions_json(context) }
    end
  end

  def deck
    # TODO can this be a /duel/1/player/1/deck.json singular resource
    # (this would be a DecksController#show)
    respond_to do |format|
      format.json { render :json => PlayerPresenter.new(player).deck_json(context) }
    end
  end

  def battlefield
    respond_to do |format|
      format.json { render :json => PlayerPresenter.new(player).battlefield_json(context) }
    end
  end

  def hand
    respond_to do |format|
      format.json { render :json => PlayerPresenter.new(player).hand_json(context) }
    end
  end

  def graveyard
    respond_to do |format|
      format.json { render :json => PlayerPresenter.new(player).graveyard_json(context) }
    end
  end

  def declare_attackers
    if params[:attacker]
      attackers = Battlefield.find(params[:attacker])
      DeclareAttackers.new(duel: duel, zone_cards: attackers).call
    end

    # and then pass
    action = GameAction.new(
      player: player,
      key: "pass"
    )
    action.do(duel)

    respond_to do |format|
      format.html { redirect_to duel_player_path duel, player }
      format.json { render :json => {success: true} }
    end
  end

  def game_action
    action = GameAction.new(
      player: player,
      key: params[:key]
    )
    action.do(duel)

    respond_to do |format|
      format.html { redirect_to duel_player_path duel, player }
      format.json { render :json => {success: true} }
    end
  end

  def request_pass
    RequestPass.new(duel: duel, player: player).call

    respond_to do |format|
      format.html { redirect_to duel_player_path duel, player }
      format.json { render :json => {success: true} }
    end
  end

  private

    def duel
      Duel.find(params[:duel_id])
    end

    def player
      Player.find(params[:id])
    end

    def action_finder
      @action_finder ||= ActionFinder.new(duel)
    end

    def current_player
      duel.players.select{ |p| p.user == current_user }.first
    end

    def context
      current_player
    end

end
