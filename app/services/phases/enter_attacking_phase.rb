class EnterAttackingPhase
  attr_reader :duel

  def initialize(duel:)
    @duel = duel
  end

  def call
    ResolveStack.new(duel: duel).call

    ClearMana.new(duel: duel).call

    RemoveUnattachedEnchantments.new(duel: duel).call
  end

end
