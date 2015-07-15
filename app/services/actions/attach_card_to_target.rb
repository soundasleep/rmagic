class AttachCardToTarget
  attr_reader :duel, :player, :card, :target

  def initialize(duel:, player:, card:, target:)
    @duel = duel
    @player = player
    @card = card
    @target = target
  end

  def call
    # add association
    card.card.update! attached_to_id: target.card.id

    # update log
    ActionLog.attach_card_action(duel, player, target.card, card.id)

    true
  end

end
