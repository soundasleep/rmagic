class TapThisCard < Action

  def execute(duel, stack)
    stack.source.card.tap_card!
  end

end
