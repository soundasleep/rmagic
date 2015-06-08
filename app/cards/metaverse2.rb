class Metaverse2 < CardType
  def name
    "Forest"
  end

  def is_land?
    true
  end

  def actions
    [ "tap" ]
  end

  def do_action(game_engine, card, index)
    case index
      when "tap"
        return do_tap(game_engine, card)
    end
    super
  end

  def do_tap(game_engine, card)
    fail "Cannot tap #{card.entity}: already tapped" if card.entity.is_tapped?

    card.player.mana_green += 1
    card.player.save!
    card.entity.tap_card!
  end
end
