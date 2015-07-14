class DeclareAttackers
  attr_reader :duel, :zone_cards

  def initialize(duel:, zone_cards:)
    @duel = duel
    @zone_cards = zone_cards
  end

  def call
    zone_cards.each do |zone_card|
      # this assumes we are always attacking the other player
      duel.declared_attackers.create! card: zone_card.card, player: zone_card.player, target_player: duel.other_player
      ActionLog.declare_card_action(duel, zone_card.player, zone_card)
    end

    true
  end

end
