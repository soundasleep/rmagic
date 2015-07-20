class BattlefieldController < ApplicationController
  include ActionableController

  before_filter :authenticate

  def ability
    action = AbilityAction.new(
      source: Battlefield.find(params[:id]),
      key: params[:key],
      target: find_target
    )
    action.do(duel)

    respond_to do |format|
      format.html { redirect_to duel_player_path duel, player }
      format.json { render :json => {success: true} }
    end
  end

  def defend
    source = Battlefield.find(params[:id])
    target = DeclaredAttacker.find(params[:target])
    action = DefenderAction.new(
      source: source,
      target: target
    )
    action.declare(duel)

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
      Player.find(params[:player_id])
    end

end
