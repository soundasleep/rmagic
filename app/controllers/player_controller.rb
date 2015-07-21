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
      format.json { render :json => @player.safe_json }
    end
  end

  def all_actions_json
    player.all_actions_json
  end

  def actions
    respond_to do |format|
      format.json { render :json => all_actions_json }
    end
  end

  def deck
    respond_to do |format|
      format.json { render :json => PlayerPresenter.new(player).deck_json }
    end
  end

  def battlefield
    respond_to do |format|
      format.json { render :json => PlayerPresenter.new(player).battlefield_json }
    end
  end

  def hand
    respond_to do |format|
      format.json { render :json => PlayerPresenter.new(player).hand_json }
    end
  end

  def graveyard
    respond_to do |format|
      format.json { render :json => PlayerPresenter.new(player).graveyard_json }
    end
  end

  def declare_attackers
    if params[:attacker]
      attackers = Battlefield.find(params[:attacker])
      DeclareAttackers.new(duel: duel, zone_cards: attackers).call
    end
    duel.save!    # TODO remove

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

end
