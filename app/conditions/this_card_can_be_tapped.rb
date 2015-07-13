class ThisCardCanBeTapped < Condition

  def evaluate(duel, stack)
    !stack.source.card.is_tapped? &&
      duel.phase.can_tap? &&
      stack.source.zone.cards_are_tappable?
  end

end
