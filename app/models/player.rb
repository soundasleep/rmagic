class Player < ActiveRecord::Base
  def deck
    Deck.where(player: self)
  end

  def hand
    Hand.where(player: self)
  end

  def battlefield
    Battlefield.where(player: self)
  end

  def graveyard
    Graveyard.where(player: self)
  end
end
