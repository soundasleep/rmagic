class Library::Metaverse6 < CardType
  include Creature

  def name
    "Creature with activated abilities"
  end

  def power
    2
  end

  def toughness
    3
  end

  def mana_cost
    Mana.new green: 1, colourless: 1
  end

  def destroy_cost
    Mana.new colourless: 1
  end

  def conditions_for_destroy
    TextualConditions.new(
      "target is a card",
      "target is in their battlefield",
      "target card is a creature",
      "we have priority",
      "we can use card abilities",
    )
  end

  def playing_destroy_goes_onto_stack?
    false
  end

  def actions_for_destroy
    TextualActions.new(
      "destroy the target battlefield card",
    )
  end

end
