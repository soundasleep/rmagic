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

  def setup_phase(game_engine)
    EnterCleanupPhase.new(duel: game_engine.duel).call
  end

end
