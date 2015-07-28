class Library::ElvishMystic < CardType
  include Creature

  def name
    "Elvish Mystic"
  end

  def power
    1
  end

  def toughness
    1
  end

  def mana_cost
    Mana.new green: 1
  end

  def self.metaverse_id
    389499
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
