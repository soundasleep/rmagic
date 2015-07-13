class DestroyTheTargetBattlefieldCard < Action

  def execute(duel, stack)
    zone_card = stack.battlefield_targets.first.target
    GameEngine.new(duel).move_into_graveyard zone_card.player, zone_card.card
  end

end
