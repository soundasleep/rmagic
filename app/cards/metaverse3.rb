class Metaverse3 < CardType
  include Playable

  def name
    "Creature with activated abilities"
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

  def add_life_cost(game_engine, card)
    return {
      green: 1
    }
  end

  def can_add_life?(game_engine, card)
    return game_engine.duel.priority_player == card.player && game_engine.duel.phase.can_instant?
  end

  # an instant
  def do_add_life(game_engine, card)
    card.player.add_life!(1)
  end

end
