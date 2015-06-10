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

  # TODO has_many battlefield etc and remove these
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

  def self.clean_mana(m)
    m[:green] ||= 0
    m[:blue] ||= 0
    m[:red] ||= 0
    m[:white] ||= 0
    m[:black] ||= 0
    m[:colourless] ||= 0
    return m
  end

  def clear_mana
    self.mana_green = 0
    self.mana_blue = 0
    self.mana_red = 0
    self.mana_white = 0
    self.mana_black = 0
    self.mana_colourless = 0
  end

  def mana_pool
    Player.clean_mana({ green: mana_green, blue: mana_blue, red: mana_red, white: mana_red, black: mana_black, colourless: mana_colourless })
  end

  def has_mana?(cost)
    cost = Player.clean_mana(cost)
    pool = mana_pool

    return use_mana_from_pool(cost, pool)
  end

  def use_mana(cost)
    cost = Player.clean_mana(cost)
    pool = mana_pool

    result = use_mana_from_pool(cost, pool)
    fail "Could not use mana #{cost} from #{pool}" unless result

    self.mana_green = result[:green]
    self.mana_blue = result[:blue]
    self.mana_red = result[:red]
    self.mana_white = result[:white]
    self.mana_black = result[:black]
    self.mana_colourless = result[:colourless]
  end

  def check_supported_colours!(pool)
    pool.keys.each do |key|
      fail "Unsupported colour key '#{key}' in pool #{pool}" unless [:green, :blue, :red, :white, :black, :colourless].include?(key)
    end
  end

  def use_mana_from_pool(cost, pool)
    check_supported_colours!(cost)
    check_supported_colours!(pool)

    [:green, :blue, :red, :white, :black].each do |c|
      (1..cost[c]).each do
        return false if pool[c] <= 0
        pool[c] -= 1
      end
    end

    (1..cost[:colourless]).each do
      if pool[:colourless] > 0
        pool[:colourless] -= 1
        next
      end
      # TODO request priority
      if pool[:green] > 0
        pool[:green] -= 1
        next
      end
      if pool[:blue] > 0
        pool[:blue] -= 1
        next
      end
      # TODO other colours

      return false
    end

    return pool
  end

end
