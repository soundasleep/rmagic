class UpdateActionChannels
  attr_reader :duel

  def initialize(duel:)
    @duel = duel
  end

  def call
    duel.reload

    duel.players.each do |player|
      player.update_action_channels "UpdateActionChannels"
    end

    true
  end

end
