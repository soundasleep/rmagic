class Metaverse1 < CardType
  def name
    "Basic creature"
  end

  def is_creature?
    true
  end

  def power
    2
  end

  def toughness
    3
  end

  def do_action(game_engine, card, index)
    case index
      when "play"
        return do_play(game_engine, card)
    end
    super
  end

  def do_play(game_engine, card)
    # add to the battlefield
    Battlefield.create!( player: card.player, entity: card.entity )
  end

end
