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
    @action_finder ||= ActionFinder.new(self)
  end

  def declare_attackers(zone_cards)
    zone_cards.each do |zone_card|
      # this assumes we are always attacking the other player
      duel.declared_attackers.create! card: zone_card.card, player: zone_card.player, target_player: duel.other_player
      ActionLog.declare_card_action(duel, zone_card.player, zone_card)
    end
  end

  def draw_card(player)
    # TODO remove references and replace with service call
    DrawCard.new(duel: duel, player: player).call
  end

  # TODO replace with Action.resolve(duel)
  def resolve_action(action)
    # TODO remove references and replace with service call
    ResolveAction.new(duel: duel, action: action).call
  end

  def declare_defender(defend)
    # update log
    ActionLog.defend_card_action(duel, defend.source.player, defend.source)

    duel.declared_defenders.create! source: defend.source, target: defend.target
  end

  def declare_defenders(defends)
    defends.each do |d|
      declare_defender d
    end
  end

  def pass
    # TODO remove references and replace with service call
    PassPriority.new(duel: duel).call
  end

  def reset_damage
    # TODO remove references and replace with service call
    ClearDamage.new(duel: duel).call
  end

  def resolve_combat
    # TODO remove references and replace with service call
    ResolveCombat.new(duel: duel).call
  end

  def remove_temporary_effects
    # TODO remove references and replace with service call
    RemoveTemporaryEffects.new(duel: duel).call
  end

  def move_destroyed_creatures_to_graveyard
    # TODO remove references and replace with service call
    MoveDestroyedCreaturesToGraveyard.new(duel: duel).call
  end

  def remove_from_all_zones(player, card)
    # TODO remove references and replace with service call
    RemoveCardFromAllZones.new(duel: duel, player: player, card: card).call
  end

  def move_into_battlefield(player, card)
    # TODO remove references and replace with service call
    MoveCardIntoBattlefield.new(duel: duel, player: player, card: card).call
  end

  def move_into_graveyard(player, card)
    # TODO remove references and replace with service call
    MoveCardOntoGraveyard.new(duel: duel, player: player, card: card).call
  end

  def move_into_stack(action)
    # TODO remove references and replace with service call
    MoveActionOntoStack.new(duel: duel, action: action).call
  end

  def add_effect(player, effect_type, target)
    # add effect
    target.card.effects.create! effect_id: effect_type.effect_id, order: target.card.next_effect_order

    # update log
    ActionLog.effect_action(duel, player, target, effect_type.effect_id)
  end

  def clear_mana
    # TODO remove references and replace with service call
    ClearMana.new(duel: duel).call
  end

  def resolve_stack
    # TODO remove references and replace with service call
    ResolveStack.new(duel: duel).call
  end

end
