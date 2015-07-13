class TargetIsAPlayer < Condition

  def evaluate(duel, stack)
    stack.target != nil &&
      stack.target.is_player?
  end

end
