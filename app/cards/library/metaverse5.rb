class Library::Metaverse5 < CardType
  include PlayableInstant

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

  def destroy_cost(game_engine, hand, target = nil)
    return {
      colourless: 1
    }
  end

  # ignoring mana costs
  def can_destroy?(game_engine, hand, target = nil)
    return target != nil &&
        target.is_card? &&
        target.player.battlefield.include?(target) &&
        target.card.card_type.is_creature? &&
        can_play_instant?(game_engine, hand)
  end

  # an instant
  def resolve_destroy(game_engine, hand, target = nil)
    game_engine.destroy target

    # and then put it into the graveyard
    game_engine.move_into_graveyard hand.player, hand
  end

end
