class Library::PinToTheEarth < CardType
  include Enchantment

  def name
    "Pin to the Earth"
  end

  def mana_cost
    Mana.new colourless: 1, blue: 1
  end

  def enchant_cost
    mana_cost
  end

  def can_enchant?
    TextualConditions.new(
      "target is a card",
      "target is in their battlefield",
      "target card is a creature",
      "we can play an enchantment",
    )
  end

  def playing_enchant_goes_onto_stack?
    true
  end

  def do_enchant
    TextualActions.new(
      "play this card",
      "attach this card to the target",
    )
  end

  def self.metaverse_id
    551481
  end

  def modify_power(n)
    n - 6
  end

end
