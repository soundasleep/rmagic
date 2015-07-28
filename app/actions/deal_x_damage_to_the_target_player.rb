class DealXDamageToTheTargetPlayer < ParameterisedAction

  def execute(duel, stack)
    player = stack.player_targets.first.target
    player.add_life!(-x)
  end

end
