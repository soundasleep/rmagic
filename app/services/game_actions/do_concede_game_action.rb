class DoConcedeGameAction
  attr_reader :duel, :player

  def initialize(duel:, player:)
    @duel = duel
    @player = player
  end

  def call
    # update the player as lost
    player.update! lost: true, final_turn: duel.turn

    # add an action log
    duel.action_logs.create! global_action: "concede", player: player

    CheckGameForWinners.new(duel: duel).call
  end

end
