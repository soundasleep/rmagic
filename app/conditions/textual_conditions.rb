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

  def describe
    parse_conditions.map do |condition|
      condition.describe
    end.join(", ")
  end

  private

    def parse_conditions
      @parsed ||= conditions.map do |string|
        if string.is_a? String
          string.tr(" ", "_").camelize.constantize.new
        else
          string
        end
      end
    end
end
