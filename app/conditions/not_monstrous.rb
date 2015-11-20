class NotMonstrous < Condition

  def evaluate(duel, stack)
    !stack.source.card.has_tag?('monstrous')
  end

end