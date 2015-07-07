class TextualConditions < Condition
  attr_reader :conditions

  def initialize(*args)
    @conditions = args
  end

  def evaluate(game_engine, stack)
    parse_conditions.all? do |condition|
      condition.evaluate(game_engine, stack)
    end
  end

  def explain(game_engine, stack)
    parse_conditions.map do |condition|
      "(" + condition.explain(game_engine, stack) + "): " + condition.evaluate(game_engine, stack).to_s
    end.join(",\n")
  end

  private

    # TODO cache?
    def parse_conditions
      conditions.map do |string|
        string.tr(" ", "_").camelize.constantize.new
      end
    end
end
