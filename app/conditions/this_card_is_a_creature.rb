class ThisCardIsACreature < Condition

  def evaluate(duel, stack)
    stack.source.card.card_type.is_creature?
  end

end
