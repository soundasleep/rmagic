class TargetCardIsACreature < Condition

  def evaluate(game_engine, stack)
    target.card.card_type.is_creature?
  end

end
