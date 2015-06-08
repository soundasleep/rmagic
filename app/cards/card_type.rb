class CardType
  def to_text
    if is_creature?
      "#{name} (#{power} / #{toughness})"
    else
      "#{name}"
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

  def do_action(game_engine, card, index)
    fail "no action #{index} defined for #{to_text}: #{actions.join(", ")}"
  end
end
