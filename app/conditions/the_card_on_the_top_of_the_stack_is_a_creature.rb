class TheCardOnTheTopOfTheStackIsACreature < Condition

  def evaluate(game_engine, stack)
    game_engine.duel.stack.last.card.card_type.is_creature?
  end

end
