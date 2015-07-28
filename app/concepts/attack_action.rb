class AttackAction
  attr_reader :source

  def initialize(source:)
    @source = source
  end

  def do(duel)
    fail "Cannot 'do' an attack"
  end

  def description
    "Attack"
  end

  def key
    "attack"
  end

end
