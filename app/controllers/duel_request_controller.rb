class DuelRequestController < ApplicationController
  before_filter :authenticate

  def index
    @user = user
  end

  def create
    premade_deck = PremadeDeck.find(params[:deck])

    result = CreateDuelRequest.new(user: user, premade_deck: premade_deck).call

    if result == true
      redirect_to user_duel_request_index_path(current_user)
    else
      redirect_to duel_player_path(result, current_user)
    end
  end

  private
    def user
      User.find(params[:user_id])
    end

end
