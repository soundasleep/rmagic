module Land
  # TODO include ActivatedAbility?

  def is_land?
    true
  end

  def play_cost(game_engine, hand, target = nil)
    mana_cost
  end

  # ignoring mana costs
  def can_play?(game_engine, hand, target = nil)
    return target == nil &&
        game_engine.duel.priority_player == hand.player &&
        game_engine.duel.current_player == hand.player &&
        game_engine.duel.phase.can_play? &&
        hand.zone.can_play_from? &&
        !has_played_a_land?(hand.player, game_engine.duel.turn)
  end

  # 305.1  Playing a land is a special action; it doesn’t use the stack (see rule 115)
  def playing_play_goes_onto_stack?
    false
  end

  # ability mana cost has already been consumed
  def do_play(game_engine, hand, target = nil)
    # put it into the battlefield
    game_engine.move_into_battlefield hand.player, hand

    # save the turn it was played
    hand.card.update! turn_played: game_engine.duel.turn
  end

  def can_tap?(game_engine, battlefield, target = nil)
    return target == nil &&
        game_engine.duel.priority_player == battlefield.player &&
        game_engine.duel.phase.can_tap? &&
        !battlefield.card.is_tapped? &&
        battlefield.zone.cards_are_tappable?
  end

  def playing_tap_goes_onto_stack?
    false
  end

  def can_untap?(game_engine, battlefield, target = nil)
    return target == nil &&
        false # we can never manually untap lands
  end

  def playing_untap_goes_onto_stack?
    false
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
