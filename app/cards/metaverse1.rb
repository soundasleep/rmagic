class Metaverse1 < CardType
  include Playable

  def name
    "Basic creature"
  end

  def is_creature?
    true
  end

  def power
    2
  end

  def toughness
    3
  end

  def mana_cost
    {
      green: 1,
      colourless: 1
    }
  end

end
