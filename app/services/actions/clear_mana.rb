class ClearMana
  attr_reader :duel

  def initialize(duel:)
    @duel = duel
  end

  def call
    duel.players.each do |player|
      player.clear_mana!
    end

    true
  end

end
