class Library::Metaverse4 < CardType
  include PlayableInstant

  def name
    "Instant add life to owner"
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

  def can_instant?
    TextualConditions.new(
      "not targeted",
      "we have priority",
      "we can play an instant",
    )
  end

  def playing_instant_goes_onto_stack?
    true
  end

  def do_instant
    TextualActions.new(
      "add 1 life to the owner of this card",
      "move this card into the graveyard",
    )
  end

end
