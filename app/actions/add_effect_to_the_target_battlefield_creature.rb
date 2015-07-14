class AddEffectToTheTargetBattlefieldCreature < Action

  attr_reader :effect

  def initialize(effect)
    @effect = effect
  end

  def execute(duel, stack)
    # add an effect
    player = stack.player
    target = stack.battlefield_targets.first.target

    AddEffect.new(duel: duel, player: player, effect_type: effect, target: target).call
  end

  def describe
    "add \"#{effect.new.name}\" to the target battlefield creature"
  end

end
