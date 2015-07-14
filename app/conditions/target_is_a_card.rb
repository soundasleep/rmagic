class TargetIsACard < Condition

  def evaluate(duel, stack)
    stack.target != nil &&
      stack.target.is_card?
  end

end
