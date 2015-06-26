module Land
  include Playable

  def is_land?
    true
  end

  def can_play?(game_engine, battlefield, target = nil)
    super(game_engine, battlefield, target) &&
        !has_played_a_land?(battlefield.player, game_engine.duel.turn)
  end

  def can_tap?(game_engine, battlefield, target = nil)
    return target == nil &&
        game_engine.duel.priority_player == battlefield.player &&
        game_engine.duel.phase.can_tap? &&
        battlefield.card.can_tap? &&
        battlefield.zone.cards_are_tappable?
  end

  def can_untap?(game_engine, battlefield, target = nil)
    return target == nil &&
        false # we can never manually untap lands
  end

  def tap_cost(game_engine, battlefield, target = nil)
    zero_mana
  end

  def untap_cost(game_engine, battlefield, target = nil)
    zero_mana
  end

  def do_tap(game_engine, battlefield, target = nil)
    fail "Cannot tap #{battlefield.card}: already tapped" if battlefield.card.is_tapped?

    battlefield.card.tap_card!
    battlefield.player.add_mana! mana_provided
  end

  def do_untap(game_engine, battlefield, target = nil)
    fail "Cannot untap #{battlefield.card}: already untapped" if !battlefield.card.is_tapped?

    battlefield.card.untap_card!
  end

  def has_played_a_land?(player, turn)
    (player.battlefield + player.graveyard).any?{ |card| card.card.turn_played == turn }
  end

end
