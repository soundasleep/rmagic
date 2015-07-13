class EnterPlayingPhase
  attr_reader :duel

  def initialize(duel:)
    @duel = duel
  end

  def call
    # TODO replace each of these with service calls
    game_engine.clear_mana
  end

  private

    def game_engine
      @game_engine ||= GameEngine.new(duel)
    end

end
