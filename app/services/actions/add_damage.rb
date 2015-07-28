class AddDamage
  attr_reader :card, :damage

  def initialize(card:, damage:)
    @card = card
    @damage = damage
  end

  def call
    card.update! damage: card.damage + damage

    true
  end

end
