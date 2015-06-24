class PossibleAbility
  attr_reader :source, :key, :target

  def initialize(source:, key:, target: nil)
    @source = source
    @key = key
    @target = target
  end

  def description
    "Use #{key} of #{source.to_text}#{target_text}"
  end

  def target_text
    if target
      " on #{target.to_text}"
    else
      ""
    end
  end

  def to_s
    {source: source, key: key, target: target}.to_s
  end
end
