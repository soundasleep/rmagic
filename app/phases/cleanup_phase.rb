class CleanupPhase < Phase
  def next_phase
    DrawingPhase.new
  end

  def to_sym
    :cleanup_phase
  end

  def description
    "cleanup phase: damage happens, cleanup destroyed cards"
  end

  def enter_phase_service
    EnterCleanupPhase
  end

end
