class Library::CounterCreature < CardType
  include PlayableInstant

  def name
    "Counter creature"
  end

  def is_instant?
    true
  end

  def mana_cost
    {
      colourless: 1
    }
  end

  def counter_creature_cost(game_engine, hand, target = nil)
    return {
      colourless: 1
    }
  end

  # ignoring mana costs
  def can_counter_creature?(game_engine, hand, target = nil)
    return target == nil &&
      !game_engine.duel.stack.empty? &&
      game_engine.duel.stack.last.card.card_type.is_creature? &&
      can_play_instant?(game_engine, hand)
  end

  # the instant resolves
  def resolve_counter_creature(game_engine, stack)
    # the stack is in bottom-top order
    target = game_engine.duel.stack.reverse.second

    fail("Trying to counter ourselves") if target == stack

    # move the next spell into the graveyard
    game_engine.move_into_graveyard stack.player, target

    # and then put this into the graveyard
    game_engine.move_into_graveyard stack.player, stack
  end

  def self.id
    14
  end

end
