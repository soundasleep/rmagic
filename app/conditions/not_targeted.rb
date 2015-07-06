class NotTargeted < Condition

  def evaluate(game_engine, stack)
    stack.target == nil
  end

end
