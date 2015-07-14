class WeCanUseAnInstant < Condition

  def evaluate(duel, stack)
    duel.phase.can_instant? &&
      stack.source.zone.can_instant_from?
  end

end
