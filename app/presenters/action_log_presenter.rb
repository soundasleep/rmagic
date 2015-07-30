class ActionLogPresenter < JSONPresenter
  def initialize(action_log)
    super(action_log)
  end

  def action_log
    object
  end

  def self.safe_json_attributes
    [ :id, :global_action, :card_action, :created_at ]
  end

  def extra_json_attributes
    {
      action_text: action_log.action_text,
      player: action_log.player ? format_player(action_log.player) : nil,
      card: action_log.card ? format_card(action_log.card) : nil,
      targets: action_log.targets.map { |t| format_target(t) }
    }
  end

  private

    def format_player(player)
      PlayerPresenter.new(player).to_json
    end

    def format_card(card)
      CardPresenter.new(card).to_json
    end

    def format_target(target)
      ActionLogTargetPresenter.new(target).to_json
    end

end
