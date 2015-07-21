class DuelPresenter < JSONPresenter
  def initialize(duel)
    super(duel)
  end

  def duel
    object
  end

  def duel_json
    to_safe_json
  end

  def action_log_json
    {
      logs: duel.action_logs.order(created_at: :desc).limit(10).map { |c| format_action_log c }
    }
  end

  def safe_json_attributes
    [ :id, :current_player_number, :priority_player_number,
      :first_player_number, :turn, :phase_number, :player1_id, :player2_id ]
  end

  def extra_json_attributes
    {
      phase: duel.phase_number,
      first_player: format_player(duel.first_player),
      current_player: format_player(duel.current_player),
      priority_player: format_player(duel.priority_player)
    }
  end

  private

    def format_action_log(action)
      ActionLogPresenter.new(action).to_safe_json
    end

    def format_player(player)
      PlayerPresenter.new(player).to_safe_json
    end

end
