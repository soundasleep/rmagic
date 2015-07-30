class StackPresenter < JSONPresenter
  def initialize(stack)
    super(stack)
  end

  def stack
    object
  end

  def stack_json
    to_json
  end

  def stack_json
    {
      stack: duel.stack.map { |c| format_stack c }
    }
  end

  def self.safe_json_attributes
    [ :order, :key, :player_id, :card_id ]
  end

  def extra_json_attributes(context = nil)
    {
      player: format_player(stack.player),
      card: format_card(stack.card),
      battlefield_targets: stack.battlefield_targets.map { |c| format_target c },
      graveyard_targets: stack.graveyard_targets.map { |c| format_target c },
      player_targets: stack.player_targets.map { |c| format_target c },
      visible: true,
    }
  end

  private

    def format_card(card)
      CardPresenter.new(card).to_json
    end

    def format_player(player)
      PlayerPresenter.new(player).to_json
    end

    def format_target(target)
      StackTargetPresenter.new(target).to_json
    end

end
