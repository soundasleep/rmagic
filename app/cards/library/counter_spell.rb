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
      target.is_spell? &&
      can_play_instant?(game_engine, hand)
  end

  # an instant
  def do_counter(game_engine, hand, target = nil)
    # TODO counter spell
    hand.player.add_life!(1)

    # and then put it into the graveyard
    game_engine.move_into_graveyard hand.player, hand
  end

  def self.id
    15
  end

end
