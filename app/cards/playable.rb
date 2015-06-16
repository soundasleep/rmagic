module Playable

  def play_cost(game_engine, card)
    mana_cost
  end

  # ignoring mana costs
  def can_play?(game_engine, card)
    return game_engine.duel.priority_player == card.player &&
        game_engine.duel.current_player == card.player &&
        game_engine.duel.phase.can_play? &&
        card.zone.can_play_from? &&
        card.entity.can_play?
  end

  # ability mana cost has already been consumed
  def do_play(game_engine, card)
    # put it into the battlefield
    game_engine.move_into_battlefield card.player, card

    # save the turn it was played
    card.entity.turn_played = game_engine.duel.turn
    card.entity.save!
  end

end
