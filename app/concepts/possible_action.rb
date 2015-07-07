class PossibleAction
  attr_reader :source, :key, :target, :action_type

  def initialize(action_type:, source:, key:, target: nil)
    @action_type = action_type
    @source = source
    @key = key
    @target = target
  end

  def description
    "#{action_description} #{key} of #{source.to_text}#{target_text}"
  end

  # TODO temporary to match up with Stack - we should create an Actionable interface
  def battlefield_targets
    [WrappedTarget.new(target)]
  end
  def graveyard_targets
    [WrappedTarget.new(target)]
  end

  class WrappedTarget
    attr_reader :target

    def initialize(target)
      @target = target
    end
  end

  # TODO refactor out of here!!!
  class PossibleActionConditions
    attr_reader :action

    def initialize(action)
      @action = action
    end

    def get_conditions
      action.source.card.card_type.get_conditions action.key
    end

    delegate :name, to: :get_conditions

    # TODO refactor out of here!!!
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

    def evaluate_with(game_engine)
      EvaluatableConditions.new self, game_engine
    end
  end

  def conditions
    PossibleActionConditions.new self
  end

  # TODO refactor out of here!!!
  class PossibleActionActions
    attr_reader :action

    def initialize(action)
      @action = action
    end

    def get_actions
      action.source.card.card_type.get_actions action.key
    end

    delegate :name, to: :get_actions

    # TODO refactor out of here!!!
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

    def execute_with(game_engine)
      ExecutableActions.new self, game_engine
    end
  end

  def actions
    PossibleActionActions.new self
  end

  def player
    source.player
  end

  def card
    source.card
  end

  private

    def target_text
      if target
        " on #{target.to_text}"
      else
        ""
      end
    end

    def to_s
      {action_type: action_type, source: source, key: key, target: target}.to_s
    end

end
