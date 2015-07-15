class HandController < ApplicationController
  include ActionableController

  before_filter :authenticate

  def play
    action = PlayAction.new(
      source: Hand.find(params[:id]),
      key: params[:key],
      target: find_target
    )
    action.do(duel)
    redirect_to duel_path duel
  end

  def defend
    source = Battlefield.find(params[:id])
    target = DeclaredAttacker.find(params[:target])
    action = DefenderAction.new(
      source: source,
      target: target
    )
    action.declare(duel)
    redirect_to duel_path duel
  end

  private
    def duel
      Duel.find(params[:duel_id])
    end

end
