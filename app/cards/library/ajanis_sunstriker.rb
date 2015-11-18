class Library::AjanisSunstriker < CardType
  include Creature

  def name
    "Ajani's Sunstriker"
  end

  def power
    2
  end

  def toughness
    2
  end

  def mana_cost
    Mana.new white: 2
  end

  def self.metaverse_id
    382211
  end

  def tags
    super << "lifelink"
  end

end
