class TargetIsAPlayer < Condition

  def evaluate(game_engine, stack)
    stack.target != nil &&
      stack.target.is_player?
  end

end
