class AddTheTemporaryCounterEffectToTheTargetBattlefieldCreature < Action

  def execute(game_engine, stack)
    # add an effect
    game_engine.add_effect stack.player, Effects::TemporaryCounter, stack.battlefield_targets.first.target
  end

end
