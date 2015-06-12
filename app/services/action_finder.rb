class ActionFinder
  def initialize(duel)
    @duel = duel
  end

  def duel
    @duel
  end

  # list all available actions for the given player
  def available_actions(player)
    actions = {
      play: [],
      tap: [],
      defend: []
    }
    if duel.phase_number == PhaseManager.playing_phase and duel.current_player == player and duel.priority_player == player
      actions[:play] += playable_cards(player)
    end
    if duel.phase_number == PhaseManager.playing_phase
      actions[:tap] += tappable_cards(player)
    end
    if duel.phase_number == PhaseManager.attacking_phase and duel.priority_player == player and duel.priority_player != duel.current_player
      actions[:defend] += defendable_cards(player)
    end
    actions
  end

  def playable_cards(player)
    # all cards where we have enough mana
    player.hand.select do |hand|
      player.has_mana? hand.entity.find_card.mana_cost
    end
  end

  def tappable_cards(player)
    # all cards which can be tapped
    player.battlefield.select do |b|
      !b.entity.is_tapped? and b.entity.find_card.is_land?
    end
  end

  def defendable_cards(player)
    # all cards on the battlefield that are not tapped and not already defending
    player.battlefield
      .reject{ |b| duel.declared_defenders.map{ |d| d.source }.include?(b) }
      .select{ |b| !b.entity.is_tapped? and b.entity.find_card.is_creature? }.map do |b|
        duel.declared_attackers.map do |a|
          {
            source: b,
            target: a
          }
        end
      end.flatten(1)
  end

end
