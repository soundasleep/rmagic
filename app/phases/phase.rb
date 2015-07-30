class Phase
  def can_tap?
    false
  end

  def can_play?
    false
  end

  def can_instant?
    false
  end

  def can_ability?
    false
  end

  def can_declare_attackers?
    false
  end

  def can_declare_defenders?
    false
  end

  def changes_player?
    false
  end

  def for_each_player?
    true
  end

  def increments_turn?
    false
  end

  def ==(phase)
    phase.is_a?(Phase) && phase.class.name == self.class.name
  end

  def name
    self.class.name.underscore.tr("_", " ")
  end

end
