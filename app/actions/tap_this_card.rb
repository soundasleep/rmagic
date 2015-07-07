class TapThisCard < Action

  def execute(game_engine, stack)
    stack.source.card.tap_card!
  end

end
