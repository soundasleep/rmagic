module Playable

  def play_cost(game_engine, hand, target = nil)
    mana_cost
  end

  # TODO should this be renamed to get_play_conditions?
  def can_play?
    TextualConditions.new(
      "not targeted",
      WeHaveMana.new(mana_cost),
      "we have priority",
      "it is our turn",
      "we can play cards",
    )
  end

  # ability mana cost has already been consumed
  # TODO should this be renamed to get_play_actions?
  def do_play
    TextualActions.new(
      "play this card",
    )
  end

  def playing_play_goes_onto_stack?
    true
  end

end
