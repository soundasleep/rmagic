class PutThisActionOntoTheStack < Action

  def execute(duel, action)
    MoveActionOntoStack.new(duel: duel, action: action).call
  end

end
