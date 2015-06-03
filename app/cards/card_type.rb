class CardType
  def to_text
    "Card #{name} (#{power} / #{toughness})"
  end

  def action_text(id)
    case id
    when 0
      "attacks"
    else
      "(unknown action #{id})"
    end
  end
end
