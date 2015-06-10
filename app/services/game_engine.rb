class GameEngine
  def initialize(duel)
    @duel = duel
  end

  def duel
    @duel
  end

  # list all available actions for the given player
  def available_actions(player)
    actions = {
      play: [],
      tap: [],
      defend: []
    }
    if @duel.phase_number == Duel.playing_phase and @duel.current_player == player and @duel.priority_player == player
      actions[:play] += playable_cards(player)
    end
    if @duel.phase_number == Duel.playing_phase
      actions[:tap] += tappable_cards(player)
    end
    if @duel.phase_number == Duel.attacking_phase and @duel.priority_player == player and @duel.priority_player != @duel.current_player
      actions[:defend] += defendable_cards(player)
    end
    actions
  end

  def playable_cards(player)
    # all cards where we have enough mana
    player.hand.select do |hand|
      player.has_mana? hand.entity.find_card!.mana_cost
    end
  end

  def tappable_cards(player)
    # all cards which can be tapped
    player.battlefield.select do |b|
      !b.entity.is_tapped? and b.entity.find_card!.is_land?
    end
  end

  def defendable_cards(player)
    # all cards on the battlefield that are not tapped and not already defending
    player.battlefield
      .reject{ |b| declared_defenders.map{ |d| d.source }.include?(b) }
      .select{ |b| !b.entity.is_tapped? and b.entity.find_card!.is_creature? }.map do |b|
        @duel.declared_attackers.map do |a|
          {
            source: b,
            target: a
          }
        end
      end.flatten(1)
  end

  # list all entities which can attack
  def available_attackers(player)
    if @duel.phase_number == Duel.attacking_phase and @duel.current_player == player and @duel.priority_player == player
      # TODO summoning sickness
      return @duel.priority_player.battlefield.select { |b| b.entity.find_card!.is_creature? }
    end
    []
  end

  def declare_attackers(cards)
    cards.each do |card|
      # this assumes we are always attacking the other player
      DeclaredAttacker.create!({duel: @duel, entity: card.entity, player: card.player, target_player: @duel.other_player})
      Action.card_action(@duel, card.player, card.entity, "declare")
    end
  end

  def play(hand)
    # remove from hand
    hand.destroy!

    # do 'play' action
    card_action hand, "play"
  end

  def draw_card(player)
    # remove from deck
    card = player.deck.first!
    card.destroy

    # add it to the hand
    Hand.create!( player: player, entity: card.entity )

    # action
    Action.draw_card_action(@duel, player)
  end

  def card_action(card, key)
    fail "No card specified" unless card

    card.entity.find_card!.do_action self, card, key

    # action
    Action.card_action(@duel, card.player, card.entity, key)

    # clear any other references
    @duel.reload
  end

  def use_mana!(player, hand)
    card = hand.entity.find_card!

    player.use_mana! card.mana_cost
  end

  def declare_defender(defend)
    fail "No :source defined" unless defend[:source]
    fail "No :target defined" unless defend[:target]

    DeclaredDefender.create!( duel: @duel, source: defend[:source], target: defend[:target] )

    # action
    Action.card_action(@duel, defend[:source].player, defend[:source].entity, "defend")
  end

  def declare_defenders(defends)
    defends.each do |d|
      declare_defender d
    end
  end

  def declared_defenders
    DeclaredDefender.where(duel: @duel)
  end

  def pass
    @duel.pass
  end

  def reset_damage
    @duel.players.each do |player|
      player.battlefield.each do |card|
        card.entity.damage = 0
        card.entity.save!
      end
    end
  end

  def apply_damage_to(action, remaining_damage, battlefield)
    if remaining_damage > 0
      if remaining_damage > battlefield.entity.remaining_health
        battlefield.entity.damage! battlefield.entity.remaining_health
        remaining_damage -= battlefield.entity.remaining_health
      else
        battlefield.entity.damage! remaining_damage
        remaining_damage = 0
      end

      # link the defender
      ActionTarget.create!( action: action, entity: battlefield.entity )
    end

    remaining_damage
  end

  def apply_attack_damage(attacker)
    # TODO allow attacker to specify order of damage
    remaining_damage = attacker.entity.find_card!.power

    action = Action.card_action(@duel, attacker.player, attacker.entity, "attack")

    @duel.declared_defenders.select { |d| d.target == attacker }.each do |d|
      remaining_damage = apply_damage_to action, remaining_damage, d.source
    end

    if remaining_damage > 0
      attacker.target_player.life -= remaining_damage
      attacker.target_player.save!
    end
  end

  def apply_defend_damage(defender)
    damage = defender.source.entity.find_card!.power

    action = Action.card_action(@duel, defender.source.player, defender.source.entity, "defended")

    # any overkill damage is ignored
    apply_damage_to action, damage, defender.target
  end

  def move_destroyed_creatures_to_graveyard
    @duel.players.each do |player|
      player.battlefield.each do |b|
        if b.entity.is_destroyed?
          b.destroy!

          # move to graveyard
          Graveyard.create!( player: b.player, entity: b.entity )

          Action.card_action(@duel, b.player, b.entity, "graveyard")
        end
      end
    end
  end

  # TODO maybe put into a phase manager service?

  def clear_mana
    @duel.players.each do |player|
      player.clear_mana!
    end
  end

  def draw_phase
    clear_mana

    # for the current player
    # untap all tapped cards for the current player
    if @duel.current_player == @duel.priority_player
      @duel.priority_player.battlefield.select { |card| card.entity.is_tapped? }.each do |card|
        card_action(card, "untap")
      end

      # the current player draws a card
      draw_card(@duel.priority_player)
    end
  end

  def play_phase
    clear_mana
  end

  def attacking_phase
    clear_mana
  end

  def cleanup_phase
    clear_mana

    @duel.declared_attackers.each do |d|
      apply_attack_damage d
    end

    @duel.declared_defenders.each do |d|
      apply_defend_damage d
    end

    # remove attackers
    DeclaredAttacker.destroy_all(duel: @duel)

    # remove defenders
    DeclaredDefender.destroy_all(duel: @duel)

    move_destroyed_creatures_to_graveyard

    # reset damage
    reset_damage

    @duel.reload
  end

end
