class MoveThisCardIntoTheBattlefield < Action

  def execute(duel, stack)
    player = stack.player
    card = stack.source.card

    MoveCardIntoBattlefield.new(duel: duel, player: player, card: card).call
  end

end
