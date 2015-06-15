class Metaverse2 < CardType
  def name
    "Forest"
  end

  def is_land?
    true
  end

  def actions
    super + [ "tap", "untap" ]
  end

  def can_do_action?(game_engine, card, index)
    case index
      when "tap"
        return card.entity.can_tap?
      when "untap"
        return card.entity.can_untap?
    end
    super
  end

  def action_cost(game_engine, card, index)
    case index
      when "tap"
        return zero_mana
      when "untap"
        return zero_mana
    end
    super
  end

  def do_action(game_engine, card, index)
    case index
      when "tap"
        return do_tap(game_engine, card)
      when "untap"
        return do_untap(game_engine, card)
    end
    super
  end

  def do_tap(game_engine, card)
    fail "Cannot tap #{card.entity}: already tapped" if card.entity.is_tapped?

    card.player.mana_green += 1
    card.player.save!
    card.entity.tap_card!
  end

  def do_untap(game_engine, card)
    fail "Cannot untap #{card.entity}: already untapped" if !card.entity.is_tapped?

    card.entity.untap_card!
  end

end
