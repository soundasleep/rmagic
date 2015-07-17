class DoAction
  attr_reader :duel, :action

  def initialize(duel:, action:)
    @duel = duel
    @action = action
  end

  def call
    fail "Cannot do an action #{action} on an empty source" unless action.source

    player = action.source.player
    cost = action.source.card.card_type.action_cost(action.key)
    if !player.has_mana?(cost)
      fail "Player #{player.to_json} can not pay for #{cost} with #{player.mana}"
    end

    # use mana
    player.use_mana! cost

    # update log
    ActionLog.card_action(duel, player, action)

    # do the thing
    action.source.card.card_type.do_action duel, action

    # update all channels
    UpdateAllChannels.new(duel: duel).call

    true
  end

end
