class GameEngine
  # TODO add a services/game_engine_spec.rb test for each of these methods
  def initialize(duel)
    @duel = duel
  end

  def duel
    @duel
  end

  def action_finder
    ActionFinder.new(self)
  end

  def phase_manager
    PhaseManager.new(self)
  end

  # list all available actions for the given player
  def available_actions(player)
    action_finder.available_actions(player)
  end

  def can_do_action?(action)
    action.source.card.card_type.can_do_action?(self, action) &&
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

  # TODO move each of these phase activities into phase objects?
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
    # use mana
    action.source.player.use_mana! action.source.card.card_type.action_cost(self, action)

    # update log
    ActionLog.card_action(duel, action.source.player, action)

    # do the thing
    action.source.card.card_type.do_action self, action
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
    remaining_damage = attacker.card.card_type.power

    action = ActionLog.attack_card_action(duel, attacker.player, attacker)

    duel.declared_defenders.select { |d| d.target == attacker }.each do |d|
      remaining_damage = apply_damage_to action, remaining_damage, d.source
    end

    if remaining_damage > 0
      attacker.target_player.remove_life! remaining_damage
    end
  end

  def apply_defend_damage(defender)
    damage = defender.source.card.card_type.power

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
          move_into_graveyard b.player, b
        end
      end
    end
  end

  def destroy(zone_card)
    # move the creature into the graveyard
    move_into_graveyard zone_card.player, zone_card
  end

  def move_into_graveyard(player, zone_card)
    # removing it from the collection, rather than object.destroy!,
    # means we don't need to reload the duel manually
    player.zones.select { |z| z.include? zone_card }.each { |z| z.destroy zone_card }

    # udpate log
    ActionLog.graveyard_card_action(duel, player, zone_card)

    # move to graveyard
    player.graveyard.create! card: zone_card.card
  end

  def move_into_battlefield(player, zone_card)
    player.zones.select { |z| z.include? zone_card }.each { |z| z.destroy zone_card }

    # update log
    ActionLog.battlefield_card_action(duel, player, zone_card)

    # move to graveyard
    player.battlefield.create! card: zone_card.card
  end

  def clear_mana
    duel.players.each do |player|
      player.clear_mana!
    end
  end

end
