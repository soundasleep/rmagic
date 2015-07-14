class TheCardOnTheTopOfTheStackIsACreature < Condition

  def evaluate(duel, stack)
    !duel.stack.empty? &&
      duel.stack.last.card.card_type.is_creature?
  end

end
