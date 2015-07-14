# TODO remove this class and all references across project - we will
# directly be using the services anyway
class GameEngine
  def initialize(duel)
    @duel = duel
  end

  def duel
    @duel
  end

  def action_finder
    # TODO replace ActionFinder.new(GameEngine) with ActionFinder.new(Duel)
    @action_finder ||= ActionFinder.new(self)
  end

  def declare_attackers(zone_cards)
    # TODO move into service
    zone_cards.each do |zone_card|
      # this assumes we are always attacking the other player
      duel.declared_attackers.create! card: zone_card.card, player: zone_card.player, target_player: duel.other_player
      ActionLog.declare_card_action(duel, zone_card.player, zone_card)
    end
  end

  def declare_defender(defend)
    # TODO move into service
    # update log
    ActionLog.defend_card_action(duel, defend.source.player, defend.source)

    duel.declared_defenders.create! source: defend.source, target: defend.target
  end

  def declare_defenders(defends)
    # TODO move into service
    defends.each do |d|
      declare_defender d
    end
  end

  def add_effect(player, effect_type, target)
    # add effect
    target.card.effects.create! effect_id: effect_type.effect_id, order: target.card.next_effect_order

    # update log
    ActionLog.effect_action(duel, player, target, effect_type.effect_id)
  end

end
