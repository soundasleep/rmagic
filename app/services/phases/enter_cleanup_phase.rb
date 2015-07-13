class EnterCleanupPhase
  attr_reader :duel

  def initialize(duel:)
    @duel = duel
  end

  def call
    # TODO replace each of these with service calls
    game_engine.resolve_stack

    game_engine.clear_mana

    game_engine.resolve_combat

    game_engine.remove_temporary_effects

    game_engine.move_destroyed_creatures_to_graveyard

    # reset damage
    game_engine.reset_damage
  end

  private

    def game_engine
      @game_engine ||= GameEngine.new(duel)
    end

end
