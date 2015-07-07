class AddMana < Action

  attr_reader :mana

  def initialize(mana)
    @mana = mana
  end

  def execute(game_engine, stack)
    stack.source.player.add_mana! mana
  end

  def describe
    "add #{mana} mana"
  end

end
