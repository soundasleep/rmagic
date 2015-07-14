# TODO remove this class and all references across project - we will
# directly be using the services anyway
class GameEngine
  def initialize(duel)
    @duel = duel
  end

  def duel
    @duel
  end

  def add_effect(player, effect_type, target)
    # add effect
    target.card.effects.create! effect_id: effect_type.effect_id, order: target.card.next_effect_order

    # update log
    ActionLog.effect_action(duel, player, target, effect_type.effect_id)
  end

end
