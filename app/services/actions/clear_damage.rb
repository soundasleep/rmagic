class ClearDamage
  attr_reader :duel

  def initialize(duel:)
    @duel = duel
  end

  def call
    duel.players.each do |player|
      player.battlefield.each do |zone_card|
        zone_card.card.update! damage: 0
      end
    end

    true
  end

end
