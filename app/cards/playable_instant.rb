module PlayableInstant

  def can_play_instant?(game_engine, hand)
    return game_engine.duel.priority_player == hand.player &&
        game_engine.duel.phase.can_instant? &&
        hand.zone.can_instant_from? &&
        hand.card.can_instant?
  end

end
