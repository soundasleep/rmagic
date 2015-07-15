class StartGame
  attr_reader :duel

  def initialize(duel:)
    @duel = duel
  end

  def call
    duel.enter_phase!

    true
  end

end
