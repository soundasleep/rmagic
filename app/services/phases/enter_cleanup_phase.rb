class EnterCleanupPhase
  attr_reader :duel

  def initialize(duel:)
    @duel = duel
  end

  def call
    # TODO replace each of these with service calls
    game_engine.resolve_stack

    game_engine.clear_mana

    ResolveCombat.new(duel: duel).call

    RemoveTemporaryEffects.new(duel: duel).call

    game_engine.move_destroyed_creatures_to_graveyard

    # reset damage
    ClearDamage.new(duel: duel).call
  end

  private

    def game_engine
      @game_engine ||= GameEngine.new(duel)
    end

end
