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

  class PossibleActionConditions
    attr_reader :action

    def initialize(action)
      @action = action
    end

    def get_conditions
      action.source.card.card_type.get_conditions action.key
    end

    delegate :name, to: :get_conditions

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
