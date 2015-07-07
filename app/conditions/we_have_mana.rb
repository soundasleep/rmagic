class WeHaveMana < Condition

  attr_reader :cost

  def initialize(cost)
    @cost = cost
  end

  def evaluate(game_engine, stack)
    stack.source.player.has_mana? cost
  end

end
