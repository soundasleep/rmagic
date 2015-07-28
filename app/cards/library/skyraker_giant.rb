class Library::SkyrakerGiant < CardType
  include Creature

  def name
    "Skyraker Giant"
  end

  def power
    4
  end

  def toughness
    3
  end

  def tags
    super << "reach"
  end

  def mana_cost
    Mana.new red: 2, colourless: 2
  end

  def self.metaverse_id
    398430
  end

end
