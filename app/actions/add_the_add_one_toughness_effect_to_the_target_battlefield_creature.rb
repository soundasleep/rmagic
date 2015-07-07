# TODO make the effect a parameter
class AddTheAddOneToughnessEffectToTheTargetBattlefieldCreature < Action

  def execute(game_engine, stack)
    # add an effect
    game_engine.add_effect stack.player, Effects::AddOneToughness, stack.battlefield_targets.first.target
  end

end
