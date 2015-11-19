class Library::KarametrasAcolyte < CardType
  include Creature

  def name
    "Karametra's Acolyte"
  end

  def power
    1
  end

  def toughness
    4
  end

  def mana_cost
    Mana.new green: 1, colourless: 3
  end

  def self.metaverse_id
    373538
  end

  def ability_cost
    Mana.new
  end

  def conditions_for_ability
    TextualConditions.new(
      "not targeted",
      "we can use card abilities",
      "this card can be tapped",
    )
  end

  def playing_ability_goes_onto_stack?
    false
  end

  def actions_for_ability
    TextualActions.new(
      "tap this card",
      "add 1 green mana to the owner of this card",
    )
  end
end
