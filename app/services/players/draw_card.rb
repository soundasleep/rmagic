class DrawCard
  attr_reader :duel, :player

  def initialize(duel:, player:)
    @duel = duel
    @player = player
  end

  def call
    # update log
    ActionLog.draw_card_action(duel, player)

    if player.deck.any?
      # remove from deck
      zone_card = player.deck.first!

      # zone_card.destroy
      # TODO instead of using card.destroy, always use collection.destroy card
      # - this means we don't need as many reload statements
      player.deck.destroy zone_card

      # add it to the hand
      player.hand.create! card: zone_card.card
    else
      if !player.lost?
        # update the player as lost (once)
        player.update! lost: true, final_turn: duel.turn

        # add an action log
        duel.action_logs.create! global_action: "lost", player: player

        # the game does not immediately end; it may end when the priority next passes
      end
    end

    true
  end

end
