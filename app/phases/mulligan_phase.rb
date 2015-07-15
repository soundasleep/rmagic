class MulliganPhase < Phase
  def next_phase
    CompletedMulligansPhase.new
  end

  def to_sym
    :mulligan_phase
  end

  def description
    "mulligan phase: initial hands are drawn, mulligans can be declared"
  end

  def enter_phase_service
    EnterMulliganPhase
  end

  def changes_player?
    true
  end

  def for_each_player?
    false
  end

end
