class Library::Metaverse3 < CardType
  include Creature
  include CreatureAbility

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
    {
      green: 1,
      colourless: 1
    }
  end

  def add_life_cost(game_engine, zone_card, target = nil)
    return {
      green: 1
    }
  end

  def can_add_life?(game_engine, zone_card, target = nil)
    return target == nil &&
        can_creature_ability?(game_engine, zone_card)
  end

  # an instant
  def do_add_life(game_engine, zone_card, target = nil)
    zone_card.player.add_life!(1)
  end

end
