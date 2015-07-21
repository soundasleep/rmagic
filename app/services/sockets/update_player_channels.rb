class UpdatePlayerChannels
  attr_reader :player

  def initialize(player:)
    @player = player
  end

  def call
    PlayerChannels.new(player).update_all

    true
  end

end
