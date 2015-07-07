class Library::KiorasFollower < CardType
  include Creature

  def name
    "Kiora's Follower"
  end

  def power
    2
  end

  def toughness
    2
  end

  def mana_cost
    Mana.new green: 1, blue: 1
  end

  def self.metaverse_id
    537713
  end

  def ability_cost
    Mana.new
  end

  def can_ability?
    TextualConditions.new(
      "target is a card",
      "target is in their battlefield",
      "target card is tapped",
      "this card can be tapped",
      "we have priority",
      "we can use card abilities",
    )
  end

  def playing_ability_goes_onto_stack?
    false
  end

  def do_ability
    TextualActions.new(
      "tap this card",
      "untap the target card",
    )
  end

end
