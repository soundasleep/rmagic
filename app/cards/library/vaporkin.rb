class Library::Vaporkin < CardType
  include Creature

  def name
    "Vaporkin"
  end

  def power
    2
  end

  def toughness
    1
  end

  def tags
    super << "flying"
  end

  def mana_cost
    Mana.new white: 1, blue: 1
  end

  def self.metaverse_id
    373547
  end

  def conditions_for_defend
    TextualConditions.new(
      super,
      "target card has a flying tag",
    )
  end

end
