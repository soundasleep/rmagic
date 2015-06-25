class Library::InstantGraveyardTop < CardType
  include PlayableInstant
  include CollectionsHelper

  def name
    "Instant return top of graveyard"
  end

  def is_instant?
    true
  end

  def mana_cost
    {
      colourless: 1
    }
  end

  def instant_cost(game_engine, hand, target = nil)
    return {
      colourless: 1
    }
  end

  # ignoring mana costs
  def can_instant?(game_engine, hand, target = nil)
    return target != nil &&
        target.is_card? &&
        target.player.graveyard.include?(target) &&
        target.player == hand.player &&
        is_first_creature?(target.player.graveyard, target) &&
        target.card.card_type.is_creature? &&
        can_play_instant?(game_engine, hand)
  end

  # an instant
  def do_instant(game_engine, hand, target = nil)
    # put target into the battlefield
    game_engine.move_into_battlefield hand.player, target

    # and then put it into the graveyard
    game_engine.move_into_graveyard hand.player, hand
  end

  def self.id
    9
  end

end
