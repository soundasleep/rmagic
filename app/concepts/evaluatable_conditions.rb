class EvaluatableConditions
  attr_reader :conditions, :duel

  def initialize(conditions, duel)
    @conditions = conditions
    @duel = duel
  end

  def evaluate
    conditions.get_conditions.evaluate duel, conditions.action
  end

  def explain
    conditions.get_conditions.explain duel, conditions.action
  end
end
