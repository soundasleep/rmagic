class Library::CounterSpell < CardType
  include PlayableInstant

  def name
    "Counter spell"
  end

  def is_instant?
    true
  end

  def mana_cost
    {
      colourless: 1
    }
  end

  def counter_cost(game_engine, hand, target = nil)
    return {
      colourless: 1
    }
  end

  # ignoring mana costs
  def can_counter?(game_engine, hand, target = nil)
    return target != nil &&
      target.is_card? &&
      target.card.card_type.is_spell? &&
      can_play_instant?(game_engine, hand)
  end

  # an instant
  def do_counter(game_engine, hand, target = nil)
    game_engine.move_into_stack hand.player, hand, "counter", target
  end

  # the instant resolves
  def resolve_counter(game_engine, stack)
    # move the target spell into the graveyard
    game_engine.move_into_graveyard stack.player, stack.target

    # and then put this into the graveyard
    game_engine.move_into_graveyard stack.player, stack
  end

  def self.id
    15
  end

end
