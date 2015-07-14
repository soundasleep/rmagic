class TargetIsInTheirGraveyard < Condition

  def evaluate(duel, stack)
    stack.target.player.graveyard.include?(stack.target)
  end

end
