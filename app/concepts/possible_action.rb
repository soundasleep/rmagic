# TODO rename to 'Action'
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

  def battlefield_targets
    [WrappedTarget.new(target)]
  end

  def graveyard_targets
    [WrappedTarget.new(target)]
  end

  def player_targets
    [WrappedTarget.new(target)]
  end

  class WrappedTarget
    attr_reader :target

    def initialize(target)
      @target = target
    end
  end

  def conditions
    ConditionsForAction.new self
  end

  def actions
    ActionsForAction.new self
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
