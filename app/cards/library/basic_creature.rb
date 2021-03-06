class Library::BasicCreature < CardType
  include Creature

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
    Mana.new green: 1, colourless: 1
  end

  def self.metaverse_id
    1
  end

end
