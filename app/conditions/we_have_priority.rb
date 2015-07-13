class WeHavePriority < Condition

  def evaluate(duel, stack)
    duel.priority_player == stack.source.player
  end

end
