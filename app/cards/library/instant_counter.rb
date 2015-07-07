class Library::InstantCounter < CardType
  include Instant

  def name
    "Instant temporary counter on creature"
  end

  def mana_cost
    Mana.new colourless: 1
  end

  def counter_cost
    Mana.new colourless: 1
  end

  def can_counter?
    TextualConditions.new(
      "target is a card",
      "target is in their battlefield",
      "target card is a creature",
      "we can play an instant",
    )
  end

  def playing_counter_goes_onto_stack?
    true
  end

  def do_counter
    TextualActions.new(
      AddEffectToTheTargetBattlefieldCreature.new(Effects::TemporaryCounter),
      "move this card into the graveyard"
    )
  end

  def self.metaverse_id
    7
  end

end
