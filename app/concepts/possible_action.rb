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
