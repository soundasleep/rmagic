class GameEngine
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

  def can_do_action?(zone_card, action)
    fail "Card #{zone_card} has nil action cost for action '#{action}'" unless zone_card.card.card_type.action_cost(self, zone_card, action)

    zone_card.card.card_type.can_do_action?(self, zone_card, action) and
      zone_card.player.has_mana? zone_card.card.card_type.action_cost(self, zone_card, action)
  end

  def available_attackers(player)
    action_finder.available_attackers(player)
  end

  def declare_attackers(zone_cards)
    zone_cards.each do |zone_card|
      # this assumes we are always attacking the other player
      DeclaredAttacker.create!({duel: duel, card: zone_card.card, player: zone_card.player, target_player: duel.other_player})
      ActionLog.card_action(duel, zone_card.player, zone_card.card, "declare")
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
    Hand.create!( player: player, card: zone_card.card )
  end

  def card_action(zone_card, key)
    fail "No zone_card specified" unless zone_card

    # use mana
    zone_card.player.use_mana! zone_card.card.card_type.action_cost(self, zone_card, key)

    # update log
    ActionLog.card_action(duel, zone_card.player, zone_card.card, key)

    # do the thing
    zone_card.card.card_type.do_action self, zone_card, key

    # clear any other references
    duel.reload
  end

  def use_mana!(player, zone_card)
    card = zone_card.card.card_type

    player.use_mana! card.mana_cost
  end

  def declare_defender(defend)
    fail "No :source defined" unless defend[:source]
    fail "No :target defined" unless defend[:target]

    # update log
    ActionLog.card_action(duel, defend[:source].player, defend[:source].card, "defend")

    DeclaredDefender.create!( duel: duel, source: defend[:source], target: defend[:target] )
    duel.reload       # TODO this seems gross!
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
      ActionLogTarget.create!( action_log: action, card: battlefield.card )
    end

    remaining_damage
  end

  def apply_attack_damage(attacker)
    # TODO allow attacker to specify order of damage
    remaining_damage = attacker.card.card_type.power

    action = ActionLog.card_action(duel, attacker.player, attacker.card, "attack")

    duel.declared_defenders.select { |d| d.target == attacker }.each do |d|
      remaining_damage = apply_damage_to action, remaining_damage, d.source
    end

    if remaining_damage > 0
      attacker.target_player.remove_life! remaining_damage
    end
  end

  def apply_defend_damage(defender)
    damage = defender.source.card.card_type.power

    action = ActionLog.card_action(duel, defender.source.player, defender.source.card, "defended")

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

  def move_into_graveyard(player, zone_card)
    zone_card.destroy!

    # udpate log
    ActionLog.card_action(duel, player, zone_card.card, "graveyard")

    # move to graveyard
    Graveyard.create!( player: zone_card.player, card: zone_card.card )
    duel.reload       # TODO this seems gross!
  end

  def move_into_battlefield(player, zone_card)
    zone_card.destroy!

    # update log
    ActionLog.card_action(duel, player, zone_card.card, "battlefield")

    # move to graveyard
    Battlefield.create!( player: zone_card.player, card: zone_card.card )
    duel.reload       # TODO this seems gross!
  end

  def clear_mana
    duel.players.each do |player|
      player.clear_mana!
    end
  end

end
