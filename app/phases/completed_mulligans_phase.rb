class CompletedMulligansPhase < Phase
  def next_phase
    DrawingPhase.new
  end

  def to_sym
    :completed_mulligans_phase
  end

  def description
    "completed mulligans phase"
  end

  def enter_phase_service
    EnterCompletedMulligansPhase
  end

  def changes_player?
    true
  end

  def for_each_player?
    false
  end

end
