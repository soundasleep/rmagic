class TheStackIsNotEmpty < Condition

  def evaluate(duel, stack)
    !duel.stack.empty?
  end

end
