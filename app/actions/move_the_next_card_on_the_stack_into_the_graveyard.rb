class MoveTheNextCardOnTheStackIntoTheGraveyard < Action

  def execute(game_engine, stack)
    # the stack is in bottom-top order
    target = game_engine.duel.stack.reverse.second

    fail("The next card on the stack is the current card on the stack") if target == stack

    # move the next spell into the graveyard
    game_engine.move_into_graveyard stack.player, target.card
  end

end
