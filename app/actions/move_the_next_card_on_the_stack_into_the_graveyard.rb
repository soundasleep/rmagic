class MoveTheNextCardOnTheStackIntoTheGraveyard < Action

  def execute(duel, stack)
    # the stack is in bottom-top order
    target = duel.stack.reverse.second

    fail("The next card on the stack is the current card on the stack") if target == stack

    # move the next spell into the graveyard
    player = stack.player
    card = target.card

    MoveCardOntoGraveyard.new(duel: duel, player: player, card: card).call
  end

end
