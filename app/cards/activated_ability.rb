module ActivatedAbility

  # TODO consider using conditions that can be debugged
  # e.g. return and(or(helpful_name, helpful_name), helpful_name)
  # which can then be debugged as
  # helpful_name = true, result = false
  def can_tap?(game_engine, zone_card, target = nil)
    return target == nil &&
        game_engine.duel.turn > zone_card.card.turn_played &&
        game_engine.duel.priority_player == zone_card.player &&
        game_engine.duel.phase.can_tap? &&
        zone_card.card.can_tap? &&
        zone_card.zone.cards_are_tappable?
  end

  def tap_cost(game_engine, zone_card, target = nil)
    zero_mana
  end

  def do_tap(game_engine, zone_card, target = nil)
    fail "Cannot tap #{zone_card.card}: already tapped" if zone_card.card.is_tapped?

    zone_card.card.tap_card!
  end

end
