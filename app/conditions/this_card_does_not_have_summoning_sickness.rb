class ThisCardDoesNotHaveSummoningSickness < Condition

  def evaluate(duel, stack)
    duel.turn > stack.source.card.turn_played
  end

end
