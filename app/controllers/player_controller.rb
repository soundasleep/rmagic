class PlayerController < ApplicationController
  include ActionableController

  before_filter :authenticate

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

    redirect_to duel_path duel
  end

  def game_action
    action = GameAction.new(
      player: player,
      key: params[:key]
    )
    action.do(duel)
    redirect_to duel_path duel
  end

  private
    def duel
      Duel.find(params[:duel_id])
    end

    def player
      Player.find(params[:id])
    end

end
