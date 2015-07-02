class Library::AddLifeTargets < CardType
  include PlayableInstant

  def name
    "Permanently add life to creature or player"
  end

  def is_instant?
    true
  end

  def mana_cost
    {
      colourless: 1
    }
  end

  def instant_player_cost(game_engine, hand, target = nil)
    return {
      colourless: 1
    }
  end

  # ignoring mana costs
  def can_instant_player?(game_engine, hand, target = nil)
    return target != nil &&
      target.is_player? &&
      can_play_instant?(game_engine, hand)
  end

  # an instant
  def resolve_instant_player(game_engine, stack)
    player = stack.player_targets.first.target
    player.add_life!(1)

    # and then put it into the graveyard
    game_engine.move_into_graveyard stack.player, stack
  end

  def counter_cost(game_engine, hand, target = nil)
    return {
      colourless: 1
    }
  end

  def instant_creature_cost(game_engine, hand, target = nil)
    return {
      colourless: 1
    }
  end

  # ignoring mana costs
  def can_instant_creature?(game_engine, hand, target = nil)
    return target != nil &&
        target.is_card? &&
        target.player.battlefield.include?(target) &&
        target.card.card_type.is_creature? &&
        can_play_instant?(game_engine, hand)
  end

  # an instant
  def resolve_instant_creature(game_engine, stack)
    # add an effect
    game_engine.add_effect stack.player, Effects::AddOneToughness.id, stack.battlefield_targets.first.target

    # and then put it into the graveyard
    game_engine.move_into_graveyard stack.player, stack
  end

  def self.id
    8
  end

end
