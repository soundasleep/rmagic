class CleanupPhase < Phase
  def next_phase
    DrawingPhase.new
  end

  # TODO replace with next_phase_is_new_turn?
  def next_phase_is_new_turn
    true
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
    DeclaredAttacker.destroy_all(duel: duel)

    # remove defenders
    DeclaredDefender.destroy_all(duel: duel)

    game_engine.move_destroyed_creatures_to_graveyard

    # reset damage
    game_engine.reset_damage

    duel.reload       # TODO this seems gross! (necessary to pick up DeclaredAttacker/DeclaredDefender changes?)
  end

end
