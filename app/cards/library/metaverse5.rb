class Library::Metaverse5 < CardType
  include Instant

  def name
    "Instant destroy creature"
  end

  def mana_cost
    Mana.new colourless: 1
  end

  def destroy_cost
    mana_cost
  end

  def conditions_for_destroy
    TextualConditions.new(
      "target is a card",
      "target is in their battlefield",
      "target card is a creature",
      "we can play an instant",
    )
  end

  def playing_destroy_goes_onto_stack?
    true
  end

  def actions_for_destroy
    TextualActions.new(
      "destroy the target battlefield card",
      "move this card onto the graveyard"
    )
  end

end
