class Library::PinToTheEarth < CardType
  include Enchantment

  def name
    "Pin to the Earth"
  end

  def mana_cost
    Mana.new colourless: 1, blue: 1
  end

  def ability_cost
    mana_cost
  end

  def can_ability?
    TextualConditions.new(
      "target is a card",
      "target is in their battlefield",
      "target card is a creature",
      "we can play an enchantment",
    )
  end

  def playing_ability_goes_onto_stack?
    true
  end

  def do_ability
    TextualActions.new(
      "play this card",
      "attach this card to the target",
    )
  end

  def self.metaverse_id
    551481
  end

end
