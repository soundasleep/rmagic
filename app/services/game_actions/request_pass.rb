class RequestPass
  attr_reader :duel

  def initialize(duel:)
    @duel = duel
  end

  def call
    # add a log
    duel.action_logs.create! duel: duel, global_action: "request_pass"

    late = Time.now - 10.seconds

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
