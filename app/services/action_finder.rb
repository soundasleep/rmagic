class ActionFinder
  attr_reader :duel

  def initialize(duel)
    @duel = duel
  end

  # from hand
  def playable_cards(player)
    playable_cards_without_targets(player)
      .concat(playable_cards_with_card_targets(player))
      .concat(playable_cards_with_player_targets(player))
      .select{ |action| action.can_do?(duel) }
  end

  # from battlefield
  def ability_cards(player)
    ability_cards_without_targets(player)
      .concat(ability_cards_with_card_targets(player))
      .concat(ability_cards_with_player_targets(player))
      .select{ |action| action.can_do?(duel) }
  end

  # from battlefield
  def defendable_cards(player)
    if duel.phase.can_declare_defenders? && duel.priority_player == player && duel.priority_player != duel.current_player
      # all cards on the battlefield that are not tapped and not already defending
      player.battlefield
        .select{ |b| b.card.card_type.can_defend? }
        .reject{ |b| duel.declared_defenders.map(&:source).include?(b) }
        .map do |b|
          duel.declared_attackers.map do |a|
            DefenderAction.new(
              source: b,
              target: a
            )
          end.select{ |action| action.can_do?(duel) }
        end.flatten(1)
    else
      []
    end
  end

  def available_attackers(player)
    if duel.phase.can_declare_attackers? and duel.current_player == player and duel.priority_player == player
      return duel.priority_player.battlefield
          .select{ |b| b.card.card_type.can_attack? }
          .select{ |b| b.card.card_type.can_do_action?(duel, AttackAction.new(source: b.card) )  }
    else
      []
    end
  end

  def game_actions(player)
    result = []
    if !duel.is_finished?
      result << GameAction.new(player: player, key: "concede")
      if duel.priority_player == player
        result << GameAction.new(player: player, key: "pass")
        if duel.mulligan_phase?
          result << GameAction.new(player: player, key: "mulligan")
        end
      end
    end
    # TODO end game actions - e.g. concede?
    result
  end

  private

    def playable_cards_without_targets(player)
      # all hand cards which have an available ability (e.g. play, instant)
      player.hand.map do |hand|
        hand.card.card_type.actions.map do |action|
          PlayAction.new(
            source: hand,
            key: action
          )
        end
      end.flatten(1)
    end

    # TODO preload player hand, card, zones etc?
    def playable_cards_with_card_targets(player)
      # all hand cards which have an available ability (e.g. play, instant)
      # with a card target
      # TODO use flat_map instead of map.flatten
      duel.players.map do |duel_player|
        duel_player.zones.map do |zone|
          zone.map do |zone_card|
            player.hand.map do |hand|
              hand.card.card_type.actions.map do |action|
                PlayAction.new(
                  source: hand,
                  key: action,
                  target: zone_card
                )
              end
            end.flatten(1)
          end.flatten(1)
        end.flatten(1)
      end.flatten(1)
      # TODO duel.all_players.all_zones.all_hands.all_cards.all_actions?
    end

    def playable_cards_with_player_targets(player)
      # all hand cards which have an available ability (e.g. play, instant)
      # with a card target
      duel.players.map do |duel_player|
        player.hand.map do |hand|
          hand.card.card_type.actions.map do |action|
            PlayAction.new(
              source: hand,
              key: action,
              target: duel_player
            )
          end
        end.flatten(1)
      end.flatten(1)
    end

    def ability_cards_without_targets(player)
      # all battlefield cards which have an available ability
      player.battlefield.map do |b|
        b.card.card_type.actions.map do |action|
          AbilityAction.new(
            source: b,
            key: action
          )
        end
      end.flatten(1)
    end

    def ability_cards_with_card_targets(player)
      # all battlefield cards which have an available ability
      # with a card target
      duel.players.map do |duel_player|
        duel_player.zones.map do |zone|
          zone.map do |zone_card|
            player.battlefield.map do |b|
              b.card.card_type.actions.map do |action|
                AbilityAction.new(
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

    def ability_cards_with_player_targets(player)
      # all battlefield cards which have an available ability
      # with a player target
      duel.players.map do |duel_player|
        player.battlefield.map do |b|
          b.card.card_type.actions.map do |action|
            AbilityAction.new(
              source: b,
              key: action,
              target: duel_player
            )
          end
        end.flatten(1)
      end.flatten(1)
    end

end
