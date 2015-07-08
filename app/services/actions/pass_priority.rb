class PassPriority
  attr_reader :duel

  def initialize(duel:)
    @duel = duel
  end

  def call
    phase_manager.pass!

    true
  end

  private
    def phase_manager
      PhaseManager.new(game_engine)
    end

    # TODO remove when we no longer have a game_engine
    def game_engine
      GameEngine.new(duel)
    end

end
