module Land
  include Playable

  def is_land?
    true
  end

  def can_tap?(game_engine, card)
    return game_engine.duel.priority_player == card.player &&
      game_engine.duel.phase.can_tap? &&
      card.entity.can_tap? &&
      card.zone.can_tap_from?
  end

  def can_untap?(game_engine, card)
    return false # we can never manually untap lands
  end

  def tap_cost(game_engine, card)
    zero_mana
  end

  def untap_cost(game_engine, card)
    zero_mana
  end

  def do_tap(game_engine, card)
    fail "Cannot tap #{card.entity}: already tapped" if card.entity.is_tapped?

    card.entity.tap_card!
    card.player.add_mana! mana_provided
  end

  def do_untap(game_engine, card)
    fail "Cannot untap #{card.entity}: already untapped" if !card.entity.is_tapped?

    card.entity.untap_card!
  end

end
