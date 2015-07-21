class UpdatePlayerChannels
  attr_reader :duel

  def initialize(duel:)
    @duel = duel
  end

  def call
    duel.players.each do |player|
      PlayerChannels.new(player).update_all
      # PlayerChannels.new(player).update_graveyard
      # instead of
      # player.update_deck_channels
      # player.update_action_channels
      # player.update_battlefield_channels
      # player.update_hand_channels
      # player.update_graveyard_channels
      player.trigger_channel_update
    end

    true
  end

end
