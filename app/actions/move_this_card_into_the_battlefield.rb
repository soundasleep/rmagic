# TODO probably split this into "PlayThisCard" (which updates turn_played)
class MoveThisCardIntoTheBattlefield < Action

  def execute(game_engine, stack)
    game_engine.move_into_battlefield stack.player, stack.source.card

    # save the turn it was played
    stack.card.update! turn_played: game_engine.duel.turn
  end

end
