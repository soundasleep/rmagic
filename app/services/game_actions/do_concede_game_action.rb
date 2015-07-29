class DoConcedeGameAction
  attr_reader :duel, :player

  def initialize(duel:, player:)
    @duel = duel
    @player = player
  end

  def call
    # update the player as lost
    player.update! lost: true

    # if there is only one player left, that player has won, and the game has ended
    remaining = duel.players.reject{ |p| p == player }.select{ |p| p.in_game? }
    if remaining.length == 1
      remaining.first.update! won: true
      duel.finished_phase!
    end
  end

end
