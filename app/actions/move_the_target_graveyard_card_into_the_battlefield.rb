class MoveTheTargetGraveyardCardIntoTheBattlefield < Action

  def execute(game_engine, stack)
    # put target into the battlefield
    game_engine.move_into_battlefield stack.player, stack.graveyard_targets.first.target.card
  end

end
