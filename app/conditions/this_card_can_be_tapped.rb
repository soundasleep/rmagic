class ThisCardCanBeTapped < Condition

  def evaluate(game_engine, stack)
    !stack.source.card.is_tapped? &&
    game_engine.duel.phase.can_tap? &&
      stack.source.zone.cards_are_tappable?
  end

end
