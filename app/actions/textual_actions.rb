class TextualActions < Condition
  attr_reader :actions, :my_caller

  def initialize(*args)
    @actions = args
    @my_caller = caller(1, 1)
  end

  def execute(game_engine, stack)
    parse_actions.all? do |condition|
      begin
        condition.execute(game_engine, stack)
      rescue => e
        # TODO maybe have our own exception class
        raise Exception.new("Could not execute condition #{condition} on #{self} from #{my_caller}: #{e}")
      end
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
        if string.is_a? String
          string.tr(" ", "_").camelize.constantize.new
        else
          string
        end
      end
    end
end
