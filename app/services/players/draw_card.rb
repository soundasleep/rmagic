class DrawCard
  attr_reader :duel, :player

  def initialize(duel:, player:)
    @duel = duel
    @player = player
  end

  def call
    # remove from deck
    zone_card = player.deck.first!
    zone_card.destroy

    # update log
    ActionLog.draw_card_action(duel, player)

    # add it to the hand
    player.hand.create! card: zone_card.card

    true
  end

end
