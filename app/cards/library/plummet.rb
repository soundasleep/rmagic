class Library::Plummet < CardType
  include Instant

  def name
    "Plummet"
  end

  def mana_cost
    Mana.new colourless: 1, green: 1
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
      "target card has a flying tag",
    )
  end

  def playing_destroy_goes_onto_stack?
    true
  end

  def actions_for_destroy
    TextualActions.new(
      "destroy the target battlefield card",
      "move this card onto the graveyard",
    )
  end

  def self.metaverse_id
    401465
  end

end
