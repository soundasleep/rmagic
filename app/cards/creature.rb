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

end
