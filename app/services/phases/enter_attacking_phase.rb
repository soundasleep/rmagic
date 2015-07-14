class EnterAttackingPhase
  attr_reader :duel

  def initialize(duel:)
    @duel = duel
  end

  def call
    ClearMana.new(duel: duel).call

    ResolveStack.new(duel: duel).call
  end

end
