class CardType
  include ManaHelper

  def to_text
    if is_creature?
      "#{name} (#{power} / #{toughness}) #{cost_string}"
    else
      "#{name} #{cost_string}"
    end
  end

  def action_text(id)
    # just use the key for now
    return "[#{id}]"
  end

  def is_creature?
    false
  end

  def is_land?
    false
  end

  def mana_cost
    {}
  end

  def cost_string
    mana_cost_string(mana_cost)
  end

  def do_action(game_engine, card, index)
    case index
      when "play"
        return do_play(game_engine, card)
    end
    fail "no action #{index} defined for #{to_text}: #{actions.join(", ")}"
  end

  # ignoring mana costs
  def can_do_action?(game_engine, card, index)
    case index
      when "play"
        return game_engine.duel.priority_player == card.player &&
            game_engine.duel.current_player == card.player &&
            game_engine.duel.phase.can_play? &&
            card.zone.can_play_from? &&
            card.entity.can_play?
    end
    fail "no action #{index} defined for #{to_text}: #{actions.join(", ")}"
  end

  def action_cost(game_engine, card, index)
    case index
      when "play"
        return mana_cost
    end
    fail "no action #{index} defined for #{to_text}: #{actions.join(", ")}"
  end

  def actions
    # TODO not all cards can be played?
    [ "play" ]
  end

  # ability mana cost has already been consumed
  def do_play(game_engine, card)
    # put it into the battlefield
    game_engine.move_into_battlefield card.player, card

    # save the turn it was played
    card.entity.turn_played = game_engine.duel.turn
    card.entity.save!
  end

end