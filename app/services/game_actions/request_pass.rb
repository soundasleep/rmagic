class RequestPass
  attr_reader :duel, :player

  def initialize(duel:, player:)
    @duel = duel
    @player = player
  end

  def call
    # add a log
    duel.action_logs.create! duel: duel, player: player, global_action: "request_pass"

    late = Time.now - 30.seconds

    if last_priority_action <= late && last_pass_action <= late
      # force a pass
      PassPriority.new(duel: duel).call
    end

    true
  end

  private

    def last_priority_action
      duel.priority_player.last_action || duel.priority_player.created_at
    end

    def last_pass_action
      duel.last_pass || duel.created_at
    end

end
