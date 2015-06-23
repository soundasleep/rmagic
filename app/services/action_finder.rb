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
      play: [],     # from hand - TODO maybe rename 'hand'
      defend: [],   # from battlefield
      ability: []   # from battlefield - TODO maybe rename 'battlefield'
    }
    actions[:play] += playable_cards(player)
    if duel.phase.can_declare_defenders? and duel.priority_player == player and duel.priority_player != duel.current_player
      actions[:defend] += defendable_cards(player)
    end
    actions[:ability] += ability_cards(player)
    actions
  end

  def playable_cards(player)
    # all hand cards which have an available ability (e.g. play, instant)
    player.hand.map do |hand|
      hand.card.card_type.actions.map do |action|
        {
          source: hand,
          action: action
        }
      end
    end.flatten(1).select{ |action| game_engine.can_do_action?(action[:source], action[:action]) }
  end

  def defendable_cards(player)
    # all cards on the battlefield that are not tapped and not already defending
    player.battlefield
      .reject{ |b| duel.declared_defenders.map{ |d| d.source }.include?(b) }
      .select{ |b| !b.card.is_tapped? and b.card.card_type.is_creature? }.map do |b|
        duel.declared_attackers.map do |a|
          {
            source: b,
            target: a
          }
        end
      end.flatten(1)
  end

  def available_attackers(player)
    if duel.phase.can_declare_attackers? and duel.current_player == player and duel.priority_player == player
      return duel.priority_player.battlefield
          .select{ |b| b.card.card_type.is_creature? }
          .select{ |b| b.card.turn_played < duel.turn }   # summoning sickness
    end
    []
  end

  def ability_cards(player)
    # all battlefield cards which have an available ability
    player.battlefield.map do |b|
      b.card.card_type.actions.map do |action|
        {
          source: b,
          action: action
        }
      end
    end.flatten(1).select{ |action| game_engine.can_do_action?(action[:source], action[:action]) }
  end

end
