class UpdateAllChannels
  attr_reader :duel

  def initialize(duel:)
    @duel = duel
  end

  def call
    UpdateDuelChannels.new(duel: duel).call
    UpdatePlayerChannels.new(duel: duel).call

    true
  end

end
