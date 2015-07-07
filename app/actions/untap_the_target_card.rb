class UntapTheTargetCard < Action

  def execute(game_engine, stack)
    stack.target.card.untap_card!
  end

end
