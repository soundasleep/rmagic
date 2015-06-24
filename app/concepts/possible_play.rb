class PossiblePlay
  attr_reader :source, :key, :target

  def initialize(source:, key:, target: nil)
    @source = source
    @key = key
    @target = target
  end

  def description
    "Play #{key} of #{source}#{target_text}"
  end

  def target_text
    if target
      " on #{target}"
    else
      ""
    end
  end

  def to_s
    {source: source, key: key, target: target}.to_s
  end
end
