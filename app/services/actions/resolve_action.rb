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
    action.card.card_type.resolve_action game_engine, action

    true
  end

  private

    # TODO eventually remove this when we no longer have a game_engine
    def game_engine
      GameEngine.new(duel)
    end
end
