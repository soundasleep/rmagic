class EnterCompletedMulligansPhase
  attr_reader :duel

  def initialize(duel:)
    @duel = duel
  end

  def call
    # if any player has declared a mulligan, go back to that phase
    if duel.players.any?{ |p| p.declared_mulligan? }
      DeclareMulligans.new(duel: duel, mulligan1: duel.player1.declared_mulligan, mulligan2: duel.player2.declared_mulligan).call

      # reset declared mulligans
      duel.players.each { |player| player.update! declared_mulligan: false }

      true
    else
      # move directly into the drawing phase
      duel.update! turn: 1
      duel.drawing_phase!
      duel.enter_phase!
      true
    end
  end

end
