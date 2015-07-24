module Tappable

  def conditions_for_untap
    TextualConditions.new(
      "never"
    )
  end

  def playing_untap_goes_onto_stack?
    false
  end

  def untap_cost
    Mana.new
  end

  def actions_for_untap
    TextualActions.new(
      "untap this card",
    )
  end

end
