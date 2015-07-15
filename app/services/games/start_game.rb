class StartGame
  attr_reader :duel

  def initialize(duel:)
    @duel = duel
  end

  def call
    duel.phase.enter_phase_service.new(duel: duel).call

    true
  end

end
