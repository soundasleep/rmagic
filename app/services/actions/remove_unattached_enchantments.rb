class RemoveUnattachedEnchantments
  attr_reader :duel

  def initialize(duel:)
    @duel = duel
  end

  def call
    duel.players.each do |p|
      unattached_enchantments(p).each do |card|
        MoveCardOntoGraveyard.new(duel: duel, player: p, card: card).call
      end
    end

    true
  end

  private

    def unattached_enchantments(player)
      player.battlefield.map { |b| b.card }
        .select { |card| card.card_type.is_enchantment? && !card.card_type.is_creature? }
        .select { |card| card.attached_to? }
    end

end
