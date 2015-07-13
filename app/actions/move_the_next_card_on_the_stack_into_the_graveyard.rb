class MoveTheNextCardOnTheStackIntoTheGraveyard < Action

  def execute(duel, stack)
    # the stack is in bottom-top order
    target = duel.stack.reverse.second

    fail("The next card on the stack is the current card on the stack") if target == stack

    # move the next spell into the graveyard
    GameEngine.new(duel).move_into_graveyard stack.player, target.card
  end

end
