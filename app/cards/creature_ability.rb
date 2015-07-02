module CreatureAbility

  def can_creature_ability?(game_engine, hand)
    return game_engine.duel.priority_player == hand.player &&
        game_engine.duel.phase.can_ability? &&
        hand.zone.can_ability_from? &&
        hand.card.can_ability?
  end

  def playing_creature_ability_goes_onto_stack?
    false
  end

end
