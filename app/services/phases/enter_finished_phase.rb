class EnterFinishedPhase
  attr_reader :duel

  def initialize(duel:)
    @duel = duel
  end

  def call
    # nothing
    true
  end

end
