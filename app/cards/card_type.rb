class CardType
  def to_text
    if is_creature?
      "#{name} (#{power} / #{toughness}) #{cost}"
    else
      "#{name} #{cost}"
    end
  end

  def action_text(id)
    # just use the key for now
    return "[#{id}]"
  end

  def is_creature?
    false
  end

  def is_land?
    false
  end

  def actions
    []
  end

  def mana_cost
    {}
  end

  def cost
    cost = Player.clean_mana mana_cost

    "{" +
      ( cost[:colourless].to_s if cost[:colourless] ) +
      ( "g" * cost[:green] ) +
      ( "u" * cost[:blue] ) +
      ( "b" * cost[:black] ) +
      ( "r" * cost[:red] ) +
      ( "w" * cost[:white] ) +
      "}"
  end

  def do_action(game_engine, card, index)
    fail "no action #{index} defined for #{to_text}: #{actions.join(", ")}"
  end
end
