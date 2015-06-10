class Player < ActiveRecord::Base
  include Mana

  has_many :deck
  has_many :hand
  has_many :battlefield
  has_many :graveyard

  after_initialize :init

  def init
    self.mana_blue ||= 0
    self.mana_green ||= 0
    self.mana_red ||= 0
    self.mana_white ||= 0
    self.mana_black ||= 0
    self.mana_colourless ||= 0
  end

  def mana
    mana_cost_string mana_pool
  end

  def clear_mana
    set_mana zero_mana
  end

  def set_mana(mana)
    self.mana_green = mana[:green]
    self.mana_blue = mana[:blue]
    self.mana_red = mana[:red]
    self.mana_white = mana[:white]
    self.mana_black = mana[:black]
    self.mana_colourless = mana[:colourless]
  end

  def mana_pool
    {
      green: mana_green,
      blue: mana_blue,
      red: mana_red,
      white: mana_red,
      black: mana_black,
      colourless: mana_colourless
    }
  end

  def has_mana?(cost)
    cost = zero_mana.merge(cost)
    pool = mana_pool

    return use_mana_from_pool(cost, pool)
  end

  def use_mana(cost)
    cost = zero_mana.merge(cost)
    pool = mana_pool

    result = use_mana_from_pool(cost, pool)
    fail "Could not use mana #{cost} from #{pool}" unless result

    set_mana result
  end

end
