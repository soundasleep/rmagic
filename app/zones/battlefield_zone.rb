class BattlefieldZone < Zone
  def cards_are_tappable?
    true
  end

  def can_activate_from?
    true
  end

end
