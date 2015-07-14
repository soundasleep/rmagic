class EnterDrawingPhase
  attr_reader :duel

  def initialize(duel:)
    @duel = duel
  end

  def call
    # TODO replace each of these with service calls
    game_engine.clear_mana

    # for the current player
    # untap all tapped cards for the current player
    if duel.current_player == duel.priority_player
      duel.priority_player.battlefield.select { |battlefield| battlefield.card.is_tapped? }.each do |battlefield|
        PossibleAbility.new(source: battlefield, key: "untap").do(duel)
      end

      # the current player draws a card
      DrawCard.new(duel: duel, player: duel.priority_player).call
    end
  end

  private

    def game_engine
      @game_engine ||= GameEngine.new(duel)
    end

end
