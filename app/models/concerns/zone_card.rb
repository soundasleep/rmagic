module ZoneCard
  include SafeJson

  def to_text
    card.to_text
  end

  def is_card?
    true
  end

  def is_player?
    false
  end

  def has_zone?
    true
  end

  def safe_json_attributes
    [:id, :card_id]
  end

  def extra_json_attributes
    {
      card: card.safe_json
    }
  end

end
