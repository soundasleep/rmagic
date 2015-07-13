class TargetIsInTheirBattlefield < Condition

  def evaluate(duel, stack)
    stack.target != nil &&
      stack.target.player.battlefield.include?(stack.target)
  end

end
