class WeCanUseCardAbilities < Condition

  def evaluate(game_engine, stack)
    game_engine.duel.phase.can_ability? &&
      stack.source.zone.can_ability_from?
  end

end
