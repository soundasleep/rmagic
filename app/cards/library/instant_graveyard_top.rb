class Library::InstantGraveyardTop < CardType
  include Instant

  def name
    "Instant return top of graveyard"
  end

  def mana_cost
    Mana.new colourless: 1
  end

  def instant_cost
    mana_cost
  end

  def conditions_for_instant
    TextualConditions.new(
      "target is a card",
      "target is in their graveyard",
      "target card is a creature",
      "target is the first creature in their graveyard",
      "we control the target",
      "we can play an instant",
    )
  end

  def playing_instant_goes_onto_stack?
    true
  end

  def actions_for_instant
    TextualActions.new(
      "move the target graveyard card into the battlefield",
      "move this card onto the graveyard",
    )
  end

  def self.metaverse_id
    9
  end

end
