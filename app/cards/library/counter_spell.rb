class Library::CounterSpell < CardType
  include Instant

  def name
    "Counter spell"
  end

  def mana_cost
    Mana.new colourless: 1
  end

  def counter_cost
    Mana.new colourless: 1
  end

  def can_counter?
    TextualConditions.new(
      "not targeted",
      "the stack is not empty",
      "the card on the top of the stack is not a creature",
      "we can play an instant",
    )
  end

  def playing_counter_goes_onto_stack?
    true
  end

  def do_counter
    TextualActions.new(
      "move the next card on the stack into the graveyard",
      "move this card into the graveyard",
    )
  end

  def self.metaverse_id
    15
  end

end
