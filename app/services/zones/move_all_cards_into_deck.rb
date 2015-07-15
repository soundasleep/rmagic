class MoveAllCardsIntoDeck
  attr_reader :duel, :player

  def initialize(duel:, player:)
    @duel = duel
    @player = player
  end

  def call
    duel.zones.each do |zone_card|
      zone_card.each do |card|
        MoveCardIntoDeck.new(duel: duel, player: player, card: card.card).call
      end
    end

    player.zones.each do |zone_card|
      zone_card.select{ |z| !z.zone.is_deck? }.each do |card|
        MoveCardIntoDeck.new(duel: duel, player: player, card: card.card).call
      end
    end

    true
  end
end
