class RequestPing
  attr_reader :duel, :player

  def initialize(duel:, player:)
    @duel = duel
    @player = player
  end

  def call
    UpdateAllChannels.new(duel: duel).call

    true
  end
end
