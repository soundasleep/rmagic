class Library::Metaverse4 < CardType
  include Instant

  def name
    "Instant add life to owner"
  end

  def mana_cost
    Mana.new colourless: 1
  end

  def instant_cost
    mana_cost
  end

  def conditions_for_instant
    TextualConditions.new(
      "not targeted",
      "we can play an instant",
    )
  end

  def playing_instant_goes_onto_stack?
    true
  end

  def actions_for_instant
    TextualActions.new(
      "add 1 life to the owner of this card",
      "move this card onto the graveyard",
    )
  end

end
