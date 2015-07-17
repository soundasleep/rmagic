class UpdatePlayerChannels
  attr_reader :duel

  def initialize(duel:)
    @duel = duel
  end

  def call
    duel.players.each do |player|
      player.trigger_channel_update
    end

    true
  end

end
