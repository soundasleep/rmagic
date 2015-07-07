class TargetCardIsTapped < Condition

  def evaluate(game_engine, stack)
    stack.target != nil &&
      stack.target.is_card? &&
      stack.target.card.is_tapped?
  end

end
