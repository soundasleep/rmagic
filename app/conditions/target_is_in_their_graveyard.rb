class TargetIsInTheirGraveyard < Condition

  def evaluate(game_engine, stack)
    stack.target.player.graveyard.include?(stack.target)
  end

end
