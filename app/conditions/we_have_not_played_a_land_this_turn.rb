class WeHaveNotPlayedALandThisTurn < Condition

  def evaluate(game_engine, stack)
    !has_played_a_land?(stack.source.player, game_engine.duel.turn)
  end

  def has_played_a_land?(player, turn)
    (player.battlefield + player.graveyard).any?{ |card| card.card.turn_played == turn }
  end

end
