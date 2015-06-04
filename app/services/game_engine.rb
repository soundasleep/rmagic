class GameEngine
  def initialize(duel)
    @duel = duel
  end

  # list all available actions
  def available_actions
    {
      play: playable_cards
    }
  end

  def playable_cards
    @duel.active_player.hand
  end

  def play(hand)
    # remove from hand
    hand.destroy!

    # add to the battlefield
    Battlefield.create!( player: hand.player, entity: hand.entity )

    # action
    Action.play_card_action(@duel, hand.player, hand.entity)
  end

end
