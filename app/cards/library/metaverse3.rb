class Library::Metaverse3 < CardType
  include Creature

  def name
    "Creature with activated abilities"
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
        game_engine.duel.priority_player == zone_card.player && game_engine.duel.phase.can_instant?
  end

  # an instant
  def do_add_life(game_engine, zone_card, target = nil)
    zone_card.player.add_life!(1)
  end

end
