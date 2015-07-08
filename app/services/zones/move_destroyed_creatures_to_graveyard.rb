class MoveDestroyedCreaturesToGraveyard
  attr_reader :duel

  def initialize(duel:)
    @duel = duel
  end

  def call
    duel.players.each do |player|
      player.battlefield.each do |b|
        if b.card.is_destroyed?
          move_into_graveyard b.player, b.card
        end
      end
    end

    true
  end

  private
    def move_into_graveyard(player, card)
      # TODO remove references and replace with service call
      MoveCardOntoGraveyard.new(duel: duel, player: player, card: card).call
    end

end
