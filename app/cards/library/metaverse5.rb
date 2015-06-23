class Library::Metaverse5 < CardType
  def name
    "Instant destroy creature"
  end

  def is_instant?
    true
  end

  def mana_cost
    {
      colourless: 1
    }
  end

  def destroy_cost(game_engine, hand)
    return {
      colourless: 1
    }
  end

  # ignoring mana costs
  def can_destroy?(game_engine, hand)
    return game_engine.duel.priority_player == hand.player &&
        game_engine.duel.phase.can_instant? &&
        hand.zone.can_instant_from? &&
        hand.card.can_instant?
  end

  # an instant
  def do_destroy(game_engine, hand)
    fail "Not implemented yet"

    # and then put it into the graveyard
    game_engine.move_into_graveyard hand.player, hand
  end

end
