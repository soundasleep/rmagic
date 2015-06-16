class CardType
  include ManaHelper
  #include Playable

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

  def actions
    methods.grep(/^do_/).map{ |m| m[3..-1] } - ["action"]
  end

  def can_do_action?(game_engine, card, index)
    send("can_#{index}?", game_engine, card)
  end

  def action_cost(game_engine, card, index)
    fail "Cannot get cost of 'action'" if index == "action"
    send("#{index}_cost", game_engine, card)
  end

  def do_action(game_engine, card, index)
    fail "Cannot do 'action'" if index == "action"
    send("do_#{index}", game_engine, card)
  end

  def play_cost(game_engine, card)
    mana_cost
  end

  # ignoring mana costs
  def can_play?(game_engine, card)
    return game_engine.duel.priority_player == card.player &&
        game_engine.duel.current_player == card.player &&
        game_engine.duel.phase.can_play? &&
        card.zone.can_play_from? &&
        card.entity.can_play?
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
