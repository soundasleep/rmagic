class MoveTheTargetGraveyardCardIntoTheBattlefield < Action

  def execute(duel, stack)
    # put target into the battlefield
    GameEngine.new(duel).move_into_battlefield stack.player, stack.graveyard_targets.first.target.card
  end

end
