class CheckGameForWinners
  attr_reader :duel

  def initialize(duel:)
    @duel = duel
  end

  def call
    # if there is only one player left, that player has won, and the game has ended
    remaining = duel.players.select{ |p| p.in_game? }
    if remaining.length == 1
      remaining.first.update! won: true

      # add an action log
      duel.action_logs.create! global_action: "won", player: remaining.first

      duel.finished_phase!
    end

    true
  end

end
