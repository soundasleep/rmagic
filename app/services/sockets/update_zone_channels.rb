class UpdateZoneChannels
  attr_reader :duel

  def initialize(duel:)
    @duel = duel
  end

  def call
    duel.reload

    duel.players.each do |player|
      player.update_zone_channels "UpdateZoneChannels"
    end

    true
  end

end
