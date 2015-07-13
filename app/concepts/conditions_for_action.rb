class ConditionsForAction
  attr_reader :action

  def initialize(action)
    @action = action
  end

  def get_conditions
    action.source.card.card_type.conditions_for action.key
  end

  delegate :name, to: :get_conditions

  def evaluate_with(duel)
    EvaluatableConditions.new self, duel
  end
end
