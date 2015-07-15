module Land

  def is_land?
    true
  end

  def play_cost
    mana_cost
  end

  # ignoring mana costs
  def can_play?
    TextualConditions.new(
      "not targeted",
      "we have priority",
      "it is our turn",
      "we can play cards",
      "we have not played a land this turn",
    )
  end

  # 305.1  Playing a land is a special action; it doesn’t use the stack (see rule 115)
  def playing_play_goes_onto_stack?
    false
  end

  # ability mana cost has already been consumed
  def do_play
    TextualActions.new(
      "play this card",
    )
  end

  def can_tap?
    TextualConditions.new(
      "not targeted",
      "we have priority",
      "this card can be tapped",
    )
  end

  def playing_tap_goes_onto_stack?
    false
  end

  def tap_cost
    Mana.new
  end

  def do_tap
    TextualActions.new(
      "tap this card",
      AddMana.new(mana_provided)
    )
  end

end
