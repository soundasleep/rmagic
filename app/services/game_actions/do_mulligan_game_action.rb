class DoMulliganGameAction
  attr_reader :duel, :player

  def initialize(duel:, player:)
    @duel = duel
    @player = player
  end

  def call
    # save that we want to mulligan
    player.update! declared_mulligan: true

    # and then pass
    PassPriority.new(duel: duel).call
  end

end
