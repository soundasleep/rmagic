class ThisCardDoesNotHaveSummoningSickness < Condition

  def evaluate(game_engine, stack)
    game_engine.duel.turn > stack.source.card.turn_played
  end

end
