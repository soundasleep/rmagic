class Metaverse4 < CardType
  def name
    "Instant add life"
  end

  def is_instant?
    true
  end

  def mana_cost
    {
      colourless: 1
    }
  end

  def actions
    [ "instant" ]
  end

  def action_cost(game_engine, card, index)
    case index
      when "instant"
        return {
          colourless: 1
        }
    end
    super
  end

  # ignoring mana costs
  def can_do_action?(game_engine, card, index)
    case index
      when "instant"
        return game_engine.duel.priority_player == card.player &&
            game_engine.duel.phase.can_instant? &&
            card.zone.can_instant_from? &&
            card.entity.can_instant?
    end
    super
  end

  def do_action(game_engine, card, index)
    case index
      when "instant"
        return do_instant(game_engine, card)
    end
    super
  end

  # an instant
  def do_instant(game_engine, card)
    card.player.add_life!(1)

    # and then put it into the graveyard
    game_engine.move_into_graveyard card.player, card
  end

end
