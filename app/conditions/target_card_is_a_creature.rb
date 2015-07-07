class TargetCardIsACreature < Condition

  def evaluate(game_engine, stack)
    stack.target.card.card_type.is_creature?
  end

end
