class DealXDamageToTheTargetPlayer < ParameterisedAction

  def execute(duel, stack)
    player = stack.player_targets.first.target
    player.remove_life! x
  end

end
