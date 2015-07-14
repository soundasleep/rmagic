class UntapThisCard < Action

  def execute(duel, stack)
    stack.source.card.untap_card!
  end

end
