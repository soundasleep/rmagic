class ResolveAction
  attr_reader :duel, :action

  def initialize(duel:, action:)
    @duel = duel
    @action = action
  end

  def call
    # update log
    # TODO ActionLog.resolve_card_action(duel, action.card.player, action)

    # do the thing
    action.card.card_type.resolve_action duel, action

    true
  end

end
