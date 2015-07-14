class NotTargeted < Condition

  def evaluate(duel, stack)
    stack.target == nil
  end

end
