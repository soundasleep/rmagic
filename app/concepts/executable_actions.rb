class ExecutableActions
  attr_reader :actions, :duel

  def initialize(actions, duel)
    @actions = actions
    @duel = duel
  end

  def execute
    actions.get_actions.execute duel, actions.action
  end

  def explain
    actions.get_actions.explain duel, actions.action
  end
end

