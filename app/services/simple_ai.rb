class SimpleAI
  # TODO replace game_engine with duel
  def do_turn(game_engine, player)
    # always declare attackers always always
    game_engine.declare_attackers action_finder(game_engine.duel).available_attackers(player)

    # really simple AI: we just pass
    PassPriority.new(duel: game_engine.duel).call
  end

  private

    def action_finder(duel)
      ActionFinder.new(duel)
    end

end
