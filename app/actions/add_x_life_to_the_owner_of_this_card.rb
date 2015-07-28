class AddXLifeToTheOwnerOfThisCard < ParameterisedAction

  def execute(duel, stack)
    stack.player.add_life! x
  end

end
