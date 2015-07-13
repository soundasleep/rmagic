class WeHaveNotPlayedALandThisTurn < Condition

  def evaluate(duel, stack)
    !has_played_a_land?(stack.source.player, duel.turn)
  end

  def has_played_a_land?(player, turn)
    (player.battlefield + player.graveyard).any?{ |card| card.card.turn_played == turn }
  end

end
