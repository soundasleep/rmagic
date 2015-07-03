class Library::InstantCounter < CardType
  include PlayableInstant

  def name
    "Instant temporary counter on creature"
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
        target.player.battlefield.include?(target) &&
        target.card.card_type.is_creature? &&
        can_play_instant?(game_engine, hand)
  end

  def playing_counter_goes_onto_stack?
    true
  end

  # an instant
  def resolve_counter(game_engine, stack)
    # add an effect
    game_engine.add_effect stack.player, Effects::TemporaryCounter, stack.battlefield_targets.first.target

    # and then put it into the graveyard
    game_engine.move_into_graveyard stack.player, stack
  end

  def self.metaverse_id
    7
  end

end
