class WeCanUseAnInstant < Condition

  def evaluate(game_engine, stack)
    game_engine.duel.phase.can_instant? &&
      stack.source.zone.can_instant_from?
  end

end
