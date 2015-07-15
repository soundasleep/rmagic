class DoGameAction
  attr_reader :duel, :player, :key

  def initialize(duel:, player:, key:)
    @duel = duel
    @player = player
    @key = key
  end

  def call
    case key
      when "pass"
        PassPriority.new(duel: duel).call

      when "mulligan"
        DoMulliganGameAction.new(duel: duel, player: player).call

      else
        fail "Unknown game action '#{key}'"
    end
  end

end
