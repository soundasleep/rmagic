class ItIsOurTurn < Condition

  def evaluate(duel, stack)
    duel.current_player == stack.source.player
  end

end
