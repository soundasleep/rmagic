class UpdateCardTurnPlayed < Action

  def execute(game_engine, stack)
    # save the turn it was played
    stack.card.update! turn_played: game_engine.duel.turn
  end

end
