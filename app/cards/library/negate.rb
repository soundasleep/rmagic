class Library::Negate < CardType
  include PlayableInstant

  def name
    "Negate"
  end

  def is_instant?
    true
  end

  def mana_cost
    Mana.new colourless: 1, blue: 1
  end

  def counter_cost(game_engine, hand, target = nil)
    mana_cost
  end

  # ignoring mana costs
  def can_counter?
    TextualConditions.new(
      "not targeted",
      "the stack is not empty",
      "the card on the top of the stack is not a creature",
      "we have priority",
      "we can play an instant",
    )
  end

  def playing_counter_goes_onto_stack?
    true
  end

  # the instant resolves
  def resolve_counter(game_engine, stack)
    # the stack is in bottom-top order
    target = game_engine.duel.stack.reverse.second

    fail("Trying to counter ourselves") if target == stack

    # move the next spell into the graveyard
    game_engine.move_into_graveyard stack.player, target

    # and then put this into the graveyard
    game_engine.move_into_graveyard stack.player, stack
  end

  def self.metaverse_id
    698824
  end

end
