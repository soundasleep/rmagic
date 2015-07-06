class ItIsOurTurn < Condition

  def evaluate(game_engine, stack)
    game_engine.duel.priority_player == stack.source.player
  end

end
