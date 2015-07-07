class Add1LifeToTheTargetPlayer < Action

  def execute(game_engine, stack)
    player = stack.player_targets.first.target
    player.add_life! 1
  end

end
