class UpdateActionChannels
  attr_reader :duel

  def initialize(duel:)
    @duel = duel
  end

  def call
    duel.players.each do |player|
      player.update_action_channels
    end

    true
  end

end
