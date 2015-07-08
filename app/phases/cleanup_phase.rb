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
    # TODO each of these could be moved into services
    # TODO this could be moved into a SetupCleanupPhase service?
    game_engine.resolve_stack

    game_engine.clear_mana

    game_engine.resolve_combat

    game_engine.remove_temporary_effects

    game_engine.move_destroyed_creatures_to_graveyard

    # reset damage
    game_engine.reset_damage
  end

end
