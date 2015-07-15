class DeclareMulligans
  attr_reader :duel, :mulligan1, :mulligan2

  def initialize(duel:, mulligan1:, mulligan2:)
    @duel = duel
    @mulligan1 = mulligan1
    @mulligan2 = mulligan2
  end

  def call
    if mulligan1
      duel.player1.update! mulligans: duel.player1.mulligans + 1
    end
    if mulligan2
      duel.player2.update! mulligans: duel.player2.mulligans + 1
    end

    if anyone_mulliganed?
      duel.mulligan_phase!
    else
      duel.drawing_phase!
    end

    duel.phase.enter_phase_service.new(duel: duel).call

    true
  end

  private
    def anyone_mulliganed?
      mulligan1 || mulligan2
    end

end
