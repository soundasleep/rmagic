class SimpleAI
  def do_turn(game_engine, player)
    # always declare attackers always always
    game_engine.declare_attackers game_engine.action_finder.available_attackers(player)

    # really simple AI: we just pass
    game_engine.pass
  end
end
