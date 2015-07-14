class Action
  def name
    self.class.name.underscore.tr("_", " ")
  end

  def execute(duel, stack)
    fail "Not implemented"
  end

  def explain(duel, stack)
    "#{name}"
  end

  def describe
    "#{name}"
  end
end
