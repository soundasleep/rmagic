class MoveDestroyedCreaturesToGraveyard
  attr_reader :duel

  def initialize(duel:)
    @duel = duel
  end

  def call
    duel.players.each do |player|
      player.battlefield.each do |b|
        if b.card.is_destroyed?
          move_onto_graveyard b.player, b.card
        end
      end
    end

    true
  end

  private
    def move_onto_graveyard(player, card)
      MoveCardOntoGraveyard.new(duel: duel, player: player, card: card).call
    end

end
