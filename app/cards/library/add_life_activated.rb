class Library::AddLifeActivated < CardType
  include Creature

  def name
    "Creature with activated add life to owner"
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

  # TODO implement Actionable interface as a superclass for Stack & PossibleAction
  def add_life_cost(game_engine, action)
    Mana.new green: 1
  end

  # TODO maybe rename to conditions_for_add_life
  def can_add_life?
    TextualConditions.new(
      "not targeted",
      "this card does not have summoning sickness",
      "we have priority",
      "this card can be tapped",
      "we can use card abilities",
    )
  end

  # TODO maybe rename to actions_for_add_life
  # an instant
  def do_add_life
    TextualActions.new(
      "tap this card",
      "add 1 life to the owner of this card",
    )
  end

  def playing_add_life_goes_onto_stack?
    false
  end

  def self.metaverse_id
    12
  end

end
