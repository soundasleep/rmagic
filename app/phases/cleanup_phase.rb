class CleanupPhase < Phase
  def next_phase
    DrawingPhase.new
  end

  def next_phase_is_new_turn
    true
  end

  def to_sym
    :cleanup_phase
  end

  def description
    "cleanup phase: damage happens, cleanup destroyed cards"
  end

end
