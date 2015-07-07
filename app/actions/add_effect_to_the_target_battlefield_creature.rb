class AddEffectToTheTargetBattlefieldCreature < Action

  attr_reader :effect

  def initialize(effect)
    @effect = effect
  end

  def execute(game_engine, stack)
    # add an effect
    game_engine.add_effect stack.player, effect, stack.battlefield_targets.first.target
  end

  def describe
    "add \"#{effect.new.name}\" to the target battlefield creature"
  end

end
