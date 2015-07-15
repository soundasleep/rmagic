class MoveCardIntoDeck
  attr_reader :duel, :player, :card

  def initialize(duel:, player:, card:)
    @duel = duel
    @player = player
    @card = card
  end

  def call
    RemoveCardFromAllZones.new(duel: duel, player: player, card: card).call or fail "Could not remove card"

    # update log
    ActionLog.deck_card_action(duel, player, card)

    # move to battlefield
    player.deck.create! card: card, order: player.next_deck_order

    true
  end
end
