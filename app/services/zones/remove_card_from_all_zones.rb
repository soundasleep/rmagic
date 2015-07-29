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
      zone.select { |z| z.card == card }.each { |e| e.destroy } # zone.destroy e.id } # e.destroy }
    end

    duel.zones.each do |zone|
      zone.select { |z| z.card == card }.each { |e| e.destroy } # zone.destroy e.id }
    end

    # It would be nice to get rid of this one day.
    # duel.reload
    # duel.zones.each { |z| z(true)  # ??
    # duel.stack(true)
    # # player.zones(true) # ??
    # player.battlefield(true)
    # player.graveyard(true)
    # player.hand(true)
    # player.deck(true)
    duel.reload

    true
  end
end
