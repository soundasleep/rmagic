class MoveThisCardIntoTheBattlefield < Action

  def execute(game_engine, stack)
    game_engine.move_into_battlefield stack.player, stack.source.card
  end

end
