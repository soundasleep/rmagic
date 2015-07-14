class SimpleAI
  # TODO replace game_engine with duel
  def do_turn(game_engine, player)
    # always declare attackers always always
    game_engine.declare_attackers game_engine.action_finder.available_attackers(player)

    # really simple AI: we just pass
    PassPriority.new(duel: game_engine.duel).call
  end
end
