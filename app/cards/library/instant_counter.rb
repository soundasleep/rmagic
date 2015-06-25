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
        target.player.battlefield.include?(target) &&
        target.card.card_type.is_creature? &&
        can_play_instant?(game_engine, hand)
  end

  # an instant
  def do_counter(game_engine, hand, target = nil)
    # add an effect
    game_engine.add_effect hand.player, Effects::TemporaryCounter.id, target

    # and then put it into the graveyard
    game_engine.move_into_graveyard hand.player, hand
  end

  def self.id
    7   # TODO add test that all card IDs are unique
  end

end
