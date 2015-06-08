class Player < ActiveRecord::Base
  after_initialize :init

  def init
    self.mana_blue ||= 0
    self.mana_green ||= 0
    self.mana_red ||= 0
    self.mana_white ||= 0
    self.mana_black ||= 0
    self.mana_colourless ||= 0
  end

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

  def mana
    r = []
    r << "#{mana_blue} blue" if mana_blue
    r << "#{mana_green} green" if mana_green
    r << "#{mana_red} red" if mana_red
    r << "#{mana_white} white" if mana_white
    r << "#{mana_black} black" if mana_black
    r << "#{mana_colourless} colourless" if mana_colourless
    r.join(", ")
  end
end
