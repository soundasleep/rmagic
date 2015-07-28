class Library::InstantCounter < CardType
  include Instant

  def name
    "Instant temporary counter on creature"
  end

  def mana_cost
    Mana.new colourless: 1
  end

  def counter_cost
    mana_cost
  end

  def conditions_for_counter
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

  def actions_for_counter
    TextualActions.new(
      AddEffectToTheTargetBattlefieldCreature.new(Effects::TemporaryCounter),
      "move this card onto the graveyard"
    )
  end

  def self.metaverse_id
    7
  end

end
