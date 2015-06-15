class Metaverse3 < CardType
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

  def actions
    super + [ "add_life" ]
  end

  def action_cost(game_engine, card, index)
    case index
      when "add_life"
        return {
          green: 1
        }
    end
    super
  end

  def can_do_action?(game_engine, card, index)
    case index
      when "add_life"
        return true
    end
    super
  end

  def do_action(game_engine, card, index)
    case index
      when "add_life"
        return do_add_life(game_engine, card)
    end
    super
  end

  # an instant
  def do_add_life(game_engine, card)
    card.player.add_life!(1)
  end

end
