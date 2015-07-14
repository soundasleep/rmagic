class MoveTheTargetGraveyardCardIntoTheBattlefield < Action

  def execute(duel, stack)
    # put target into the battlefield
    player = stack.player
    card = stack.graveyard_targets.first.target.card

    MoveCardIntoBattlefield.new(duel: duel, player: player, card: card).call
  end

end
