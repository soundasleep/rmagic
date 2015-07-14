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
      PhaseManager.new(duel)
    end

end
