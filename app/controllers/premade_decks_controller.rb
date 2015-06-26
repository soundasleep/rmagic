class PremadeDecksController < ApplicationController
  def index
    @decks = PremadeDeck.all
  end

  def show
    @deck = PremadeDeck.find(params[:id])
  end
end
