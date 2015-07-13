class MoveThisCardIntoTheGraveyard < Action

  def execute(duel, stack)
    GameEngine.new(duel).move_into_graveyard stack.player, stack.source.card
  end

end
