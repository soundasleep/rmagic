class PutThisActionOntoTheStack < Action

  def execute(game_engine, action)
    game_engine.move_into_stack action.source.player, action.source.card, action.key, action.target
  end

end
