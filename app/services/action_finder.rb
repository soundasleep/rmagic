class ActionFinder
  def initialize(game_engine)
    @game_engine = game_engine
  end

  def game_engine
    @game_engine
  end

  def duel
    game_engine.duel
  end

  # list all available actions for the given player
  def available_actions(player)
    actions = {
      play: [],
      tap: [],
      defend: [],
      ability: []
    }
    if duel.playing_phase? and duel.current_player == player and duel.priority_player == player
      actions[:play] += playable_cards(player)
    end
    if duel.playing_phase?
      actions[:tap] += tappable_cards(player)
    end
    if duel.attacking_phase? and duel.priority_player == player and duel.priority_player != duel.current_player
      actions[:defend] += defendable_cards(player)
    end
    if duel.priority_player == player
      actions[:ability] += ability_cards(player)
    end
    actions
  end

  def playable_cards(player)
    # all cards where we have enough mana
    player.hand.select do |hand|
      player.has_mana? hand.entity.find_card.action_cost(game_engine, hand, "play")
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

  def available_attackers(player)
    if duel.attacking_phase? and duel.current_player == player and duel.priority_player == player
      return duel.priority_player.battlefield
          .select{ |b| b.entity.find_card.is_creature? }
          .select{ |b| b.entity.turn_played < duel.turn }   # summoning sickness
    end
    []
  end

  def ability_cards(player)
    # all cards which have an available ability
    player.battlefield.map do |b|
      b.entity.find_card.actions.map do |action|
        {
          source: b,
          action: action
        }
      end
    end.flatten(1).select{ |action| game_engine.can_do_action?(action[:source], action[:action]) }
  end

end
