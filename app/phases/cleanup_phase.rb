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
    duel = game_engine.duel

    game_engine.clear_mana

    game_engine.apply_attack_damages duel.declared_attackers

    game_engine.apply_defend_damages duel.declared_defenders

    # remove attackers
    duel.declared_attackers.destroy_all

    # remove defenders
    duel.declared_defenders.destroy_all

    game_engine.move_destroyed_creatures_to_graveyard

    # reset damage
    game_engine.reset_damage
  end

end
