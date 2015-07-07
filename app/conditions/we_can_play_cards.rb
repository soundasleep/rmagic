class WeCanPlayCards < Condition

  def evaluate(game_engine, stack)
    game_engine.duel.phase.can_play? &&
      stack.source.zone.can_play_from?
  end

end
