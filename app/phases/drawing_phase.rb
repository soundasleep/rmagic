class DrawingPhase < Phase
  def next_phase
    PlayingPhase.new
  end

  def to_sym
    :drawing_phase
  end

  def changes_player?
    true
  end

  def description
    "drawing phase: draw cards"
  end

  def enter_phase_service
    EnterDrawingPhase
  end

end
