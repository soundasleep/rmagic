class DuelPresenter < JSONPresenter
  def initialize(duel)
    super(duel)
  end

  def duel
    object
  end

  def duel_json
    to_json
  end

  def action_logs_json
    {
      logs: duel.action_logs.order(created_at: :desc).limit(20).map { |c| format_action_log c }
    }
  end

  def stack_json
    {
      stack: duel.stack.map { |c| format_stack c }
    }
  end

  def self.safe_json_attributes
    [ :id, :created_at, :current_player_number, :priority_player_number,
      :first_player_number, :turn, :phase_number, :player1_id, :player2_id ]
  end

  def extra_json_attributes(context = nil)
    {
      phase: duel.phase_number,
      last_pass: duel.last_pass,
      last_action: duel.priority_player.last_action,
      first_player: format_player(duel.first_player),
      current_player: format_player(duel.current_player),
      priority_player: format_player(duel.priority_player),
      is_finished: duel.is_finished?,
    }
  end

  private

    def format_action_log(action)
      ActionLogPresenter.new(action).to_json
    end

    def format_player(player)
      PlayerPresenter.new(player).to_json
    end

    def format_stack(stack)
      StackPresenter.new(stack).to_json
    end

end
