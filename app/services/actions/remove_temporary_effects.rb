class RemoveTemporaryEffects
  attr_reader :duel

  def initialize(duel:)
    @duel = duel
  end

  def call
    duel.players.each do |p|
      p.battlefield.each do |b|
        b.card.effects.select { |e| e.effect_type.until_end_of_turn? }.each do |e|
          b.card.effects.destroy e
        end
      end
    end

    true
  end

end
