class EnterMulliganPhase
  attr_reader :duel

  def initialize(duel:)
    @duel = duel
  end

  def call
    duel.players.each do |player|
      MoveAllCardsIntoDeck.new(duel: duel, player: player).call

      ShuffleDeck.new(duel: duel, player: player).call

      # draw N cards
      (7 - player.mulligans).times do
        DrawCard.new(duel: duel, player: player).call
      end
    end
  end

end
