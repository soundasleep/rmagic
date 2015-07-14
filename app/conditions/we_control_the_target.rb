class WeControlTheTarget < Condition

  def evaluate(duel, stack)
    stack.target.player == stack.source.player
  end

end
