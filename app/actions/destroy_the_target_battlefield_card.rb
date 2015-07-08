class DestroyTheTargetBattlefieldCard < Action

  def execute(game_engine, stack)
    zone_card = stack.battlefield_targets.first.target
    game_engine.move_into_graveyard zone_card.player, zone_card.card
  end

end
