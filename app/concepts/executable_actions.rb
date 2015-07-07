class ExecutableActions
  attr_reader :actions, :game_engine

  def initialize(actions, game_engine)
    @actions = actions
    @game_engine = game_engine
  end

  def execute
    actions.get_actions.execute game_engine, actions.action
  end

  def explain
    actions.get_actions.explain game_engine, actions.action
  end
end

