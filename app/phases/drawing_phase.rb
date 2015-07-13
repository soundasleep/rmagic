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

  def setup_phase(game_engine)
    EnterDrawingPhase.new(duel: game_engine.duel).call
  end

end
