class AddOurDevotionToGreenAsGreenManaToTheOwnerOfThisCard < Action
  def execute(duel, stack)
    green = stack.source.player.devotion.green

    stack.source.player.add_mana! Mana.new( green: green )
  end
end
