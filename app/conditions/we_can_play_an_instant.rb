class WeCanPlayAnInstant < Condition

  # TODO refactor into a textual condition with (we have priority) and (...)
  # TODO test that textual conditions are composable
  def evaluate(game_engine, stack)
    game_engine.duel.phase.can_instant? &&
      stack.source.zone.can_instant_from?
  end

end
