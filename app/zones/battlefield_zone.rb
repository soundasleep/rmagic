class BattlefieldZone < Zone
  def cards_are_tappable?
    true
  end

  def can_ability_from?
    true
  end

  def is_battlefield?
    true
  end

end
