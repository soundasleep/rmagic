class SimpleAI
  attr_reader :duel
  attr_reader :player

  def do_turn(duel, player)
    @duel = duel
    @player = player

    # play as many cards as possible
    while playable_cards.any? || ability_cards.any? do
      if playable_cards.any?
        playable_cards.first.do duel
      elsif ability_cards.any?
        ability_cards.first.do duel
      end
    end

    # always declare attackers always always
    DeclareAttackers.new(duel: duel, zone_cards: available_attackers).call

    # really simple AI: we just pass
    PassPriority.new(duel: duel).call

    duel.reload

    # update all channels
    UpdateAllChannels.new(duel: duel).call
  end

  private

    def playable_cards
      action_finder.playable_cards(player)
    end

    def ability_cards
      action_finder.ability_cards(player)
    end

    def available_attackers
      action_finder.available_attackers(player)
    end

    def action_finder
      @action_finder ||= ActionFinder.new(duel)
    end

end
