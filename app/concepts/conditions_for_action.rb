class ConditionsForAction
  attr_reader :action

  def initialize(action)
    @action = action
  end

  def get_conditions
    action.source.card.card_type.conditions_for action.key
  end

  delegate :name, to: :get_conditions

  def evaluate_with(game_engine)
    EvaluatableConditions.new self, game_engine
  end
end
