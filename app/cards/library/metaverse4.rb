class Library::Metaverse4 < CardType
  include PlayableInstant

  def name
    "Instant add life to owner"
  end

  def is_instant?
    true
  end

  def mana_cost
    {
      colourless: 1
    }
  end

  def instant_cost(game_engine, hand, target = nil)
    return {
      colourless: 1
    }
  end

  # ignoring mana costs
  def can_instant?(game_engine, hand, target = nil)
    return target == nil &&
      can_play_instant?(game_engine, hand)
  end

  # the instant resolves
  def resolve_instant(game_engine, stack)
    stack.player.add_life!(1)

    # and then put it into the graveyard
    game_engine.move_into_graveyard stack.player, stack
  end

end
