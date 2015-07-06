class Action
  def name
    self.class.name
  end

  def execute(game_engine, stack)
    fail "Not implemented"
  end
end
