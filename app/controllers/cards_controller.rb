class CardsController < ApplicationController
  def index
    @cards = CardUniverse.new.all
  end

  def show
    @card = CardUniverse.new.find_metaverse(params[:id]) or fail("Could not find card #{params[:id]}")
  end
end
