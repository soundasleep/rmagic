class TheStackIsNotEmpty < Condition

  def evaluate(game_engine, stack)
    !game_engine.duel.stack.empty?
  end

end
