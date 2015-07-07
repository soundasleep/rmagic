class DestroyTheTargetBattlefieldCard < Action

  def execute(game_engine, stack)
    game_engine.destroy stack.battlefield_targets.first.target
  end

end
