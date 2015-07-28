class AddXGreenManaToTheOwnerOfThisCard < ParameterisedAction

  def execute(duel, stack)
    stack.source.player.add_mana! Mana.new( green: x )
  end

end
