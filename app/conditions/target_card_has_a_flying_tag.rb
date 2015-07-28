class TargetCardHasAFlyingTag < Condition

  def evaluate(duel, stack)
    stack.target.card.has_tag? "flying"
  end

end
