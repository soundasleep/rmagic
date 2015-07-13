class PutThisActionOntoTheStack < Action

  def execute(duel, action)
    GameEngine.new(duel).move_into_stack action
  end

end
