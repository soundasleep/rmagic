class Condition
  def name
    self.class.name
  end

  def evaluate(game_engine, stack)
    fail "Not implemented"
  end

  def explain(game_engine, stack)
    "#{name} on #{game_engine} with #{stack}"
  end
end
