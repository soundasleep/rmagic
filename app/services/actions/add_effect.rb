class AddEffect
  attr_reader :duel, :player, :effect_type, :target

  def initialize(duel:, player:, effect_type:, target:)
    @duel = duel
    @player = player
    @effect_type = effect_type
    @target = target
  end

  def call
    # add effect
    target.card.effects.create! effect_id: effect_type.effect_id, order: target.card.next_effect_order

    # update log
    ActionLog.effect_action(duel, player, target, effect_type.effect_id)

    true
  end

end
