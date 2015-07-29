class CardsController < ApplicationController
  def index
    @cards = CardUniverse.new.all
  end

  def show
    @card = CardUniverse.new.find_metaverse(params[:id]) or fail("Could not find card #{params[:id]}")
  end

  def styles
    @cards = CardUniverse.new.all

    expires_in 1.day, :public => true
  end
end
