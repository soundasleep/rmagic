class TargetIsInTheirBattlefield < Condition

  def evaluate(game_engine, stack)
    stack.target.player.battlefield.include?(stack.target)
  end

end
