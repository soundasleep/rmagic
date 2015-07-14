class DestroyTheTargetBattlefieldCard < Action

  def execute(duel, stack)
    zone_card = stack.battlefield_targets.first.target
    player = zone_card.player
    card = zone_card.card

    MoveCardOntoGraveyard.new(duel: duel, player: player, card: card).call
  end

end
