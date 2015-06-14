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

  def actions
    []
  end

  def mana_cost
    {}
  end

  def cost_string
    mana_cost_string(mana_cost)
  end

  def do_action(game_engine, card, index)
    fail "no action #{index} defined for #{to_text}: #{actions.join(", ")}"
  end

  def do_play(game_engine, card)
    # use mana
    game_engine.use_mana!(card.player, card)

    # add to the battlefield
    Battlefield.create!( player: card.player, entity: card.entity )

    # save the turn it was played
    card.entity.turn_played = game_engine.duel.turn
    card.entity.save!
  end

end
