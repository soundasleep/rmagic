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
    Mana.new colourless: 1
  end

  def instant_cost(game_engine, hand, target = nil)
    Mana.new colourless: 1
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

  def playing_instant_goes_onto_stack?
    true
  end

  # an instant
  def resolve_instant(game_engine, stack)
    # put target into the battlefield
    game_engine.move_into_battlefield stack.player, stack.graveyard_targets.first.target

    # and then put it into the graveyard
    game_engine.move_into_graveyard stack.player, stack
  end

  def self.metaverse_id
    9
  end

end
