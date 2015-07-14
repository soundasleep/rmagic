class DeclareDefender
  attr_reader :duel, :defend

  def initialize(duel:, defend:)
    @duel = duel
    @defend = defend
  end

  def call
    # update log
    ActionLog.defend_card_action(duel, defend.source.player, defend.source)

    duel.declared_defenders.create! source: defend.source, target: defend.target

    true
  end

end
