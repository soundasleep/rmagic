class ThisCardCanBeTapped < Condition

  def evaluate(game_engine, stack)
    game_engine.duel.phase.can_tap? &&
      stack.source.zone.cards_are_tappable?
  end

end
