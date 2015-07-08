class PutThisActionOntoTheStack < Action

  def execute(game_engine, action)
    game_engine.move_into_stack action
  end

end
