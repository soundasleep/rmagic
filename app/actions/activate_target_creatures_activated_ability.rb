class ActivateTargetCreaturesActivatedAbility < Action
  attr_reader :effect

  def initialize(effect)
    @effect = effect
  end

  def execute(duel, stack)
    player = stack.player
    target = stack.source.card

    AddEffect.new(duel: duel, player: player, effect_type: effect, target: target).call
  end

  def describe
    "add \"#{effect.new.name}\" to the target battlefield creature"
  end

end