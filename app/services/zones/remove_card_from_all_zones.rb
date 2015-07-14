class RemoveCardFromAllZones
  attr_reader :duel, :player, :card

  def initialize(duel:, player:, card:)
    @duel = duel
    @player = player
    @card = card
  end

  def call
    fail "#{card} is not a card" unless card.is_a? Card

    player.zones.each do |zone|
      zone.select { |z| z.card == card }.each { |e| e.destroy }
    end

    duel.zones.each do |zone|
      zone.select { |z| z.card == card }.each { |e| e.destroy }
    end

    # It would be nice to get rid of this one day.
    duel.reload

    true
  end
end
