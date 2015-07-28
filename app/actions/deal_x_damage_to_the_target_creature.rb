class DealXDamageToTheTargetCreature < ParameterisedAction

  def execute(duel, stack)
    card = stack.battlefield_targets.first.target
    AddDamage.new(card: card.card, damage: x).call
  end

end
