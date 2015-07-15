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
    redirect_to duel_player_path duel, player
  end

  private
    def duel
      Duel.find(params[:duel_id])
    end

    def player
      Player.find(params[:player_id])
    end

end
