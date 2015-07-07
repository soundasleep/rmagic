class Library::Metaverse3 < CardType
  include Creature

  def name
    "Creature with add life to owner"
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

  def add_life_cost(game_engine, zone_card, target = nil)
    Mana.new green: 1
  end

  def can_add_life?
    TextualConditions.new(
      "not targeted",
      "we have priority",
      "we can use card abilities",
    )
  end

  def playing_add_life_goes_onto_stack?
    false
  end

  # an instant
  def do_add_life(game_engine, zone_card, target = nil)
    zone_card.player.add_life!(1)
  end

end
