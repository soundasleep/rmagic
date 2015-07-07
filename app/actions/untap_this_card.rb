class UntapThisCard < Action

  def execute(game_engine, stack)
    stack.source.card.untap_card!
  end

end
