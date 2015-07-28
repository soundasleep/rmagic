class Library::JacesIngenuity < CardType
  include Instant

  def name
    "Jace's Ingenuity"
  end

  def mana_cost
    Mana.new colourless: 3, blue: 2
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
      "draw 3 cards",
      "move this card onto the graveyard",
    )
  end

  def self.metaverse_id
    205015
  end

end
