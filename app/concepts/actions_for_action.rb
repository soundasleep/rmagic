class ActionsForAction
  attr_reader :action

  def initialize(action)
    @action = action
  end

  def get_actions
    action.source.card.card_type.actions_for action.key
  end

  delegate :name, to: :get_actions

  def execute_with(game_engine)
    ExecutableActions.new self, game_engine
  end
end
