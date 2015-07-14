class UntapTheTargetCard < Action

  def execute(duel, stack)
    stack.target.card.untap_card!
  end

end
