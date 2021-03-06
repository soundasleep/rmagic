class TargetCardIsACreature < Condition

  def evaluate(duel, stack)
    stack.target != nil &&
      stack.target.card.card_type.is_creature?
  end

end
