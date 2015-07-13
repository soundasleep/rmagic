class WeCanUseCardAbilities < Condition

  def evaluate(duel, stack)
    duel.phase.can_ability? &&
      stack.source.zone.can_ability_from?
  end

end
