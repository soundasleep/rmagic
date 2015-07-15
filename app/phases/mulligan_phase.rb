class MulliganPhase < Phase
  def next_phase
    DrawingPhase.new
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

end
