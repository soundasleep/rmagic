class SimpleAI
  def do_turn(duel, player)
    # always declare attackers always always
    attackers = action_finder(duel).available_attackers(player)
    DeclareAttackers.new(duel: duel, zone_cards: attackers).call

    # really simple AI: we just pass
    PassPriority.new(duel: duel).call
  end

  private

    def action_finder(duel)
      ActionFinder.new(duel)
    end

end
