class DrawingPhase < Phase
  def next_phase
    PlayingPhase.new
  end

  def to_sym
    :drawing_phase
  end

  def changes_player?
    true
  end

  def description
    "drawing phase: draw cards"
  end

  def setup_phase(game_engine)
    duel = game_engine.duel

    game_engine.clear_mana

    # for the current player
    # untap all tapped cards for the current player
    if duel.current_player == duel.priority_player
      duel.priority_player.battlefield.select { |battlefield| battlefield.card.is_tapped? }.each do |battlefield|
        game_engine.card_action(PossibleAbility.new(source: battlefield, key: "untap"))
      end

      # the current player draws a card
      game_engine.draw_card(duel.priority_player)
    end
  end

end
