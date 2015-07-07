class Library::Metaverse5 < CardType
  include PlayableInstant

  def name
    "Instant destroy creature"
  end

  def is_instant?
    true
  end

  def mana_cost
    Mana.new colourless: 1
  end

  def destroy_cost(game_engine, hand, target = nil)
    Mana.new colourless: 1
  end

  def can_destroy?
    TextualConditions.new(
      "target is a card",
      "target is in their battlefield",
      "target card is a creature",
      "we have priority",
      "we can play an instant",
    )
  end

  def playing_destroy_goes_onto_stack?
    true
  end

  def do_destroy
    TextualActions.new(
      "destroy the target battlefield card",
      "move this card into the graveyard"
    )
  end

end
