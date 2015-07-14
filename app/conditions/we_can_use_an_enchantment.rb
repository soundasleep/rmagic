class WeCanUseAnEnchantment < Condition

  def evaluate(duel, stack)
    duel.phase.can_play? &&
      stack.source.zone.can_play_from?
  end

end
