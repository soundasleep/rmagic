module Playable

  def play_cost(game_engine, hand)
    mana_cost
  end

  # ignoring mana costs
  def can_play?(game_engine, hand)
    return game_engine.duel.priority_player == hand.player &&
        game_engine.duel.current_player == hand.player &&
        game_engine.duel.phase.can_play? &&
        hand.zone.can_play_from? &&
        hand.card.can_play?
  end

  # ability mana cost has already been consumed
  def do_play(game_engine, hand)
    # put it into the battlefield
    game_engine.move_into_battlefield hand.player, hand

    # save the turn it was played
    hand.card.update! turn_played: game_engine.duel.turn
  end

end
