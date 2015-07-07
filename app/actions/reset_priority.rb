class ResetPriority < Action

  def execute(game_engine, action)
    game_engine.duel.reset_priority!
  end

end
