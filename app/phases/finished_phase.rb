class FinishedPhase < Phase
  def next_phase
    FinishedPhase.new
  end

  def to_sym
    :finished_phase
  end

  def description
    "finished phase: game is over"
  end

  def enter_phase_service
    EnterFinishedPhase
  end

  def changes_player?
    false
  end

  def for_each_player?
    false
  end

end
