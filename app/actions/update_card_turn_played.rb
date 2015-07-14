class UpdateCardTurnPlayed < Action

  def execute(duel, stack)
    # save the turn it was played
    stack.card.update! turn_played: duel.turn
  end

end
