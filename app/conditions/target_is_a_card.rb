class TargetIsACard < Condition

  def evaluate(game_engine, stack)
    stack.target != nil &&
      stack.target.is_creature?
  end

end
