class Condition
  def name
    self.class.name.underscore.tr("_", " ")
  end

  def evaluate(game_engine, stack)
    fail "Not implemented"
  end

  def explain(game_engine, stack)
    "#{name}"
  end

  def describe
    "#{name}"
  end
end
