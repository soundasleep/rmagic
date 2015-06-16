class PlayingPhase < Phase
  def can_tap?
    true
  end

  def can_instant?
    true
  end

  def can_play?
    true
  end

  def next_phase
    AttackingPhase.new
  end

  def to_sym
    :playing_phase
  end

  def description
    "playing phase: play cards, cast creatures"
  end

  def setup_phase(game_engine)
    game_engine.clear_mana
  end

end
