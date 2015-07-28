# TODO rename to CompositeAction?
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
        # TODO is there a better way to wrap exceptions in the stack trace?
        puts Exception.new("Could not execute action #{action} on #{self} from #{my_caller}: #{e}")
        raise e
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
  # TODO don't indent private

    def parse_actions
      # TODO maybe move out into separate helper service thing so that the class is smaller
      @parsed ||= actions.map do |string|   # TODO rename string -> subaction
        # TODO if thing.responds_to?(:execute)
        if string.is_a? String
          parameters = {}
          resolved = string.tr(" ", "_").gsub(/([0-9]+)/) do |arg|
            # future work: add more than one parameter
            parameters[:x] = arg
            "x"
          end

          if parameters.any?
            resolved.camelize.constantize.new(parameters)
          else
            resolved.camelize.constantize.new
          end
        else
          string
        end
      end
    end
end
