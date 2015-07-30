module ZoneCard

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

  def is_visible_to?(player)
    self.player == player
  end

end
