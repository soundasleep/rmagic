module Creature
  include Playable
  include Tappable

  def is_creature?
    true
  end

  def conditions_for_attack
    TextualConditions.new(
      "this card is a creature",
      "this card does not have summoning sickness",
    )
  end

  def conditions_for_defend
    TextualConditions.new(
      "this card is a creature",
      "this card can be tapped",
      "this card can block target card",
    )
  end

  def defend_cost
    Mana.new
  end

end
