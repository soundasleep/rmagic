class Library::Negate < CardType
  include Instant

  def name
    "Negate"
  end

  def mana_cost
    Mana.new colourless: 1, blue: 1
  end

  # TODO add library test to check that all actions have an associated cost defined
  def counter_creature_cost
    mana_cost
  end

  def can_counter_creature?
    TextualConditions.new(
      "not targeted",
      "the stack is not empty",
      "the card on the top of the stack is a creature",
      "we can play an instant",
    )
  end

  def playing_counter_creature_goes_onto_stack?
    true
  end

  def do_counter_creature
    TextualActions.new(
      "move the next card on the stack into the graveyard",
      "move this card into the graveyard",
    )
  end

  def self.metaverse_id
    698824
  end

end
