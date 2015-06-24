class ActionFinder
  def initialize(game_engine)
    @game_engine = game_engine
  end

  def game_engine
    @game_engine
  end

  def duel
    game_engine.duel
  end

  # list all available actions for the given player
  def available_actions(player)
    actions = {
      play: [],     # from hand - TODO maybe rename 'hand'
      defend: [],   # from battlefield
      ability: []   # from battlefield - TODO maybe rename 'battlefield'
    }
    actions[:play] += playable_cards(player)
    if duel.phase.can_declare_defenders? and duel.priority_player == player and duel.priority_player != duel.current_player
      actions[:defend] += defendable_cards(player)
    end
    actions[:ability] += ability_cards(player)
    actions
  end

  def playable_cards(player)
    playable_cards_without_targets(player)
      .concat(playable_cards_with_targets(player))
      .select{ |action| game_engine.can_do_action?(action) }
  end

  def playable_cards_without_targets(player)
    # all hand cards which have an available ability (e.g. play, instant)
    player.hand.map do |hand|
      hand.card.card_type.actions.map do |action|
        PossiblePlay.new(
          source: hand,
          key: action
        )
      end
    end.flatten(1)
  end

  def playable_cards_with_targets(player)
    # all hand cards which have an available ability (e.g. play, instant)
    # with a target
    duel.players.map do |duel_player|
      duel_player.zones.map do |zone|
        zone.map do |zone_card|
          player.hand.map do |hand|
            hand.card.card_type.actions.map do |action|
              PossiblePlay.new(
                source: hand,
                key: action,
                target: zone_card
              )
            end
          end.flatten(1)
        end.flatten(1)
      end.flatten(1)
    end.flatten(1)
  end

  def defendable_cards(player)
    # all cards on the battlefield that are not tapped and not already defending
    player.battlefield
      .reject{ |b| duel.declared_defenders.map{ |d| d.source }.include?(b) }
      .select{ |b| !b.card.is_tapped? and b.card.card_type.is_creature? }.map do |b|
        duel.declared_attackers.map do |a|
          PossibleDefender.new(
            source: b,
            target: a
          )
        end
      end.flatten(1)
  end

  def available_attackers(player)
    # TODO replace with PossibleAttacker
    if duel.phase.can_declare_attackers? and duel.current_player == player and duel.priority_player == player
      return duel.priority_player.battlefield
          .select{ |b| b.card.card_type.is_creature? }
          .select{ |b| b.card.turn_played < duel.turn }   # summoning sickness
    end
    []
  end

  def ability_cards(player)
    ability_cards_without_targets(player)
      .concat(ability_cards_with_targets(player))
      .select{ |action| game_engine.can_do_action?(action) }
  end

  def ability_cards_without_targets(player)
    # all battlefield cards which have an available ability
    player.battlefield.map do |b|
      b.card.card_type.actions.map do |action|
        PossibleAbility.new(
          source: b,
          key: action
        )
      end
    end.flatten(1)
  end

  def ability_cards_with_targets(player)
    # all battlefield cards which have an available ability
    # with a target
    duel.players.map do |duel_player|
      duel_player.zones.map do |zone|
        zone.map do |zone_card|
          player.battlefield.map do |b|
            b.card.card_type.actions.map do |action|
              PossibleAbility.new(
                source: b,
                key: action,
                target: zone_card
              )
            end
          end.flatten(1)
        end.flatten(1)
      end.flatten(1)
    end.flatten(1)
  end

end
