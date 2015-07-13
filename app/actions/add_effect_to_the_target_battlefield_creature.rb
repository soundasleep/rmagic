class AddEffectToTheTargetBattlefieldCreature < Action

  attr_reader :effect

  def initialize(effect)
    @effect = effect
  end

  def execute(duel, stack)
    # add an effect
    GameEngine.new(duel).add_effect stack.player, effect, stack.battlefield_targets.first.target
  end

  def describe
    "add \"#{effect.new.name}\" to the target battlefield creature"
  end

end
