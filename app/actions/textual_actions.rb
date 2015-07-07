class TextualActions < Condition
  attr_reader :actions

  def initialize(*args)
    @actions = args
  end

  def execute(game_engine, stack)
    parse_actions.all? do |condition|
      condition.execute(game_engine, stack)
    end
  end

  def explain(game_engine, stack)
    parse_actions.map do |condition|
      "(" + condition.explain(game_engine, stack) + ")"
    end.join(",\n")
  end

  private

    # TODO cache?
    def parse_actions
      actions.map do |string|
        string.tr(" ", "_").camelize.constantize.new
      end
    end
end
