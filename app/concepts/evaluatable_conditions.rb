class EvaluatableConditions
  attr_reader :conditions, :game_engine

  def initialize(conditions, game_engine)
    @conditions = conditions
    @game_engine = game_engine
  end

  def evaluate
    conditions.get_conditions.evaluate game_engine, conditions.action
  end

  def explain
    conditions.get_conditions.explain game_engine, conditions.action
  end
end
