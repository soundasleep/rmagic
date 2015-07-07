class WeControlTheTarget < Condition

  def evaluate(game_engine, stack)
    stack.target.player == stack.source.player
  end

end
