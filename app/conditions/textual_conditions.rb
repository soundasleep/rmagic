class TextualConditions < Condition
  attr_reader :conditions, :my_caller

  def initialize(*args)
    @conditions = args
    @my_caller = caller(1, 1)
  end

  def evaluate(duel, stack)
    parse_conditions.all? do |condition|
      begin
        condition.evaluate(duel, stack)
      rescue => e
        raise Exception.new("Could not execute condition #{condition} on #{self} from #{my_caller}: #{e}")
      end
    end
  end

  def explain(duel, stack)
    parse_conditions.map do |condition|
      "(" + condition.explain(duel, stack) + "): " + condition.evaluate(duel, stack).to_s
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
