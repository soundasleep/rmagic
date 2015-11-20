class Library::IllTemperedCyclops < CardType
  include Creature

  def name
    "Ill-Tempered Cyclops"
  end

  def power
    3
  end

  def toughness
    3
  end

  def mana_cost
    Mana.new red: 1, colourless: 3
  end

  def self.metaverse_id
    373545
  end

  def tags
    super << "trample"
  end

end
