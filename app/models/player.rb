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

  def draw_card(duel)
    # get the first card
    card = deck.first!
    card.destroy

    Hand.new({ player: self, entity: card.entity }).save

    # action
    Action.draw_card_action(duel, self).save
  end
end
