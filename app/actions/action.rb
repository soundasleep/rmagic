class Action
  def name
    self.class.name
  end

  def execute(game_engine, stack)
    fail "Not implemented"
  end

  def explain(game_engine, stack)
    "#{name} on #{game_engine} with #{stack}"
  end
end
