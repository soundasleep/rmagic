class Library::SuntailHawk < CardType
  include Creature

  def name
    "Suntail Hawk"
  end

  def power
    1
  end

  def toughness
    1
  end

  def tags
    # TODO display the "flying" tag on the web interface/JSON
    super << "flying"
  end

  def mana_cost
    Mana.new white: 1
  end

  def self.metaverse_id
    370720
  end

end
