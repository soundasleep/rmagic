class MoveThisCardIntoTheGraveyard < Action

  def execute(game_engine, stack)
    game_engine.move_into_graveyard stack.player, stack
  end

end
