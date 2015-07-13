class TextualActions < Condition
  attr_reader :actions, :my_caller

  def initialize(*args)
    @actions = args
    @my_caller = caller(1, 1)
  end

  def execute(duel, stack)
    parse_actions.all? do |action|
      begin
        action.execute(duel, stack)
      rescue => e
        raise Exception.new("Could not execute action #{action} on #{self} from #{my_caller}: #{e}")
      end
    end
  end

  def explain(duel, stack)
    parse_actions.map do |action|
      "(" + action.explain(duel, stack) + ")"
    end.join(",\n")
  end

  def describe
    parse_actions.map do |action|
      action.describe
    end.join(", ")
  end

  private

    def parse_actions
      @parsed ||= actions.map do |string|
        if string.is_a? String
          string.tr(" ", "_").camelize.constantize.new
        else
          string
        end
      end
    end
end
