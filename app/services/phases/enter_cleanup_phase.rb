class EnterCleanupPhase
  attr_reader :duel

  def initialize(duel:)
    @duel = duel
  end

  def call
    ResolveStack.new(duel: duel).call

    ClearMana.new(duel: duel).call

    RemoveUnattachedEnchantments.new(duel: duel).call

    ResolveCombat.new(duel: duel).call

    RemoveTemporaryEffects.new(duel: duel).call

    MoveDestroyedCreaturesToGraveyard.new(duel: duel).call

    ClearDamage.new(duel: duel).call
  end

end
