class AddMana < Action

  attr_reader :mana

  def initialize(mana)
    @mana = mana
  end

  def execute(duel, stack)
    stack.source.player.add_mana! mana
  end

  def describe
    "add #{mana} mana"
  end

end
