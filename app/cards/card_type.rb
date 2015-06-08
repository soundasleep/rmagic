class CardType
  def to_text
    if is_creature?
      "#{name} (#{power} / #{toughness})"
    else
      "#{name}"
    end
  end

  def action_text(id)
    case id
    when 0
      "attacks"
    else
      "(unknown action #{id})"
    end
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
