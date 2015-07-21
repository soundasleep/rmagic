class UpdateDuelChannels
  attr_reader :duel

  def initialize(duel:)
    @duel = duel
  end

  def call
    DuelChannels.new(duel).update_all

    true
  end

end
