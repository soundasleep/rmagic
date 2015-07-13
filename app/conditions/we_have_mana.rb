class WeHaveMana < Condition

  attr_reader :cost

  def initialize(cost)
    @cost = cost
  end

  def evaluate(duel, stack)
    stack.source.player.has_mana? cost
  end

  def describe
    "we have #{cost} mana"
  end

end
