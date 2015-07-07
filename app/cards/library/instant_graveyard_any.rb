class Library::InstantGraveyardAny < CardType
  include PlayableInstant
  include CollectionsHelper

  def name
    "Instant return any from graveyard"
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
  def can_instant?
    TextualConditions.new(
      "target is a card",
      "target is in their graveyard",
      "target card is a creature",
      "we control the target",
      "we have priority",
      "we can play an instant",
    )
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
    10
  end

end
