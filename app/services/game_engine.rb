class GameEngine
  # TODO add a services/game_engine_spec.rb test for each of these methods
  def initialize(duel)
    @duel = duel
  end

  def duel
    @duel
  end

  def action_finder
    @action_finder ||= ActionFinder.new(self)
  end

  def phase_manager
    @phase_manager ||= PhaseManager.new(self)
  end

  def can_do_action?(action)
    action.source.card.card_type.can_do_action?(self, action) &&
      # TODO remove the has_mana? - this has been moved to the condition evaluators
      action.source.player.has_mana?(action.source.card.card_type.action_cost(self, action))
  end

  def available_attackers(player)
    action_finder.available_attackers(player)
  end

  def declare_attackers(zone_cards)
    zone_cards.each do |zone_card|
      # this assumes we are always attacking the other player
      duel.declared_attackers.create! card: zone_card.card, player: zone_card.player, target_player: duel.other_player
      ActionLog.declare_card_action(duel, zone_card.player, zone_card)
    end
  end

  # TODO move each of these into services! then we can test each of the services
  # individually
  # services return true, false etc - easier to test pass/failure
  def draw_card(player)
    # remove from deck
    zone_card = player.deck.first!
    zone_card.destroy

    # update log
    ActionLog.draw_card_action(duel, player)

    # add it to the hand
    player.hand.create! card: zone_card.card
  end

  def card_action(action)
    fail "Cannot do an action #{action} on an empty source" unless action.source

    player = action.source.player
    cost = action.source.card.card_type.action_cost(self, action)
    if !player.has_mana?(cost)
      fail "Player #{player.to_json} can not pay for #{cost} with #{player.mana}"
    end

    # use mana
    player.use_mana! cost

    # update log
    ActionLog.card_action(duel, player, action)

    # do the thing
    action.source.card.card_type.do_action self, action
  end

  def resolve_action(action)
    # update log
    # TODO ActionLog.resolve_card_action(duel, action.card.player, action)

    # do the thing
    action.card.card_type.resolve_action self, action
  end

  def use_mana!(player, zone_card)
    card = zone_card.card.card_type

    player.use_mana! card.mana_cost
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
    phase_manager.pass!
  end

  def reset_damage
    duel.players.each do |player|
      player.battlefield.each do |zone_card|
        zone_card.card.update! damage: 0
      end
    end
  end

  def apply_damage_to(action, remaining_damage, battlefield)
    if remaining_damage > 0
      if remaining_damage > battlefield.card.remaining_health
        battlefield.card.damage! battlefield.card.remaining_health
        remaining_damage -= battlefield.card.remaining_health
      else
        battlefield.card.damage! remaining_damage
        remaining_damage = 0
      end

      # link the defender
      action.targets.create! card: battlefield.card
    end

    remaining_damage
  end

  def apply_attack_damage(attacker)
    # TODO allow attacker to specify order of damage
    remaining_damage = attacker.card.power

    action = ActionLog.attack_card_action(duel, attacker.player, attacker)

    duel.declared_defenders.select { |d| d.target == attacker }.each do |d|
      remaining_damage = apply_damage_to action, remaining_damage, d.source
    end

    if remaining_damage > 0
      attacker.target_player.remove_life! remaining_damage
    end
  end

  def apply_defend_damage(defender)
    damage = defender.source.card.power

    action = ActionLog.defended_card_action(duel, defender.source.player, defender.source)

    # any overkill damage is ignored
    apply_damage_to action, damage, defender.target
  end

  def apply_attack_damages(attackers)
    attackers.each do |d|
      apply_attack_damage d
    end
  end

  def apply_defend_damages(defenders)
    defenders.each do |d|
      apply_defend_damage d
    end
  end

  def move_destroyed_creatures_to_graveyard
    duel.players.each do |player|
      player.battlefield.each do |b|
        if b.card.is_destroyed?
          move_into_graveyard b.player, b.card
        end
      end
    end
  end

  def destroy(zone_card)
    # move the creature into the graveyard
    move_into_graveyard zone_card.player, zone_card.card
  end

  def remove_from_all_zones(player, card)
    fail "#{card} is not a card" unless card.is_a? Card

    player.zones.each do |zone|
      zone.select { |z| z.card == card }.each { |e| e.destroy }
    end

    duel.zones.each do |zone|
      zone.select { |z| z.card == card }.each { |e| e.destroy }
    end

    # TODO can we please remove these?
    player.reload
    duel.reload
  end

  def move_into_graveyard(player, card)
    remove_from_all_zones(player, card)

    # update log
    ActionLog.graveyard_card_action(duel, player, card)

    # move to graveyard
    player.graveyard.create! card: card, order: player.next_graveyard_order
  end

  def move_into_battlefield(player, card)
    remove_from_all_zones(player, card)

    # update log
    ActionLog.battlefield_card_action(duel, player, card)

    # move to graveyard
    player.battlefield.create! card: card
  end

  def move_into_stack(player, zone_card, action_key, target = nil)
    remove_from_all_zones(player, zone_card.card)

    # update log
    ActionLog.stack_card_action(duel, player, zone_card)

    # move to stack
    stack = duel.stack.create! card: zone_card.card, player: player, order: duel.next_stack_order, key: action_key

    if target
      if target.has_zone?
        if target.zone.is_battlefield?
          stack.battlefield_targets.create! target: target
        elsif target.zone.is_graveyard?
          stack.graveyard_targets.create! target: target
        else
          fail "Unknown target zone #{target.zone}"
        end
      else
        stack.player_targets.create! target: target
      end
    end
  end

  def add_effect(player, effect_type, target)
    # add effect
    target.card.effects.create! effect_id: effect_type.effect_id, order: target.card.next_effect_order

    # update log
    ActionLog.effect_action(duel, player, target, effect_type.effect_id)
  end

  def clear_mana
    duel.players.each do |player|
      player.clear_mana!
    end
  end

  def resolve_stack
    i = 0

    # stack is in bottom-top order
    while !duel.stack.empty? do
      # the actions may modify the stack itself, so we loop instead of each
      target = duel.stack.reverse.first

      resolve_action target

      i += 1
      fail("Resolving the stack never completed after #{i} iterations") if i > 100
    end

    duel.stack.destroy_all
  end

end
