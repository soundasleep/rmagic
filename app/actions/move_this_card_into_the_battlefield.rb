class MoveThisCardIntoTheBattlefield < Action

  def execute(duel, stack)
    GameEngine.new(duel).move_into_battlefield stack.player, stack.source.card
  end

end
