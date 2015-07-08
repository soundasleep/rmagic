class MoveCardOntoGraveyard
  attr_reader :duel, :player, :card

  def initialize(duel:, player:, card:)
    @duel = duel
    @player = player
    @card = card
  end

  def call
    RemoveCardFromAllZones.new(duel: duel, player: player, card: card).call or fail "Could not remove card"

    # update log
    ActionLog.graveyard_card_action(duel, player, card)

    # move to graveyard
    player.graveyard.create! card: card, order: player.next_graveyard_order

    true
  end
end
