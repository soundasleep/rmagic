class EnterDrawingPhase
  attr_reader :duel

  def initialize(duel:)
    @duel = duel
  end

  def call
    ClearMana.new(duel: duel).call

    # for the current player
    # untap all tapped cards for the current player
    if duel.current_player == duel.priority_player
      duel.priority_player.battlefield.select { |battlefield| battlefield.card.is_tapped? }.each do |battlefield|
        AbilityAction.new(source: battlefield, key: "untap").do(duel)
      end

      if player_should_draw_a_card?
        DrawCard.new(duel: duel, player: duel.priority_player).call
      end
    end
  end

  private
    def player_should_draw_a_card?
      duel.turn != 1 || duel.priority_player != duel.first_player
    end

end
