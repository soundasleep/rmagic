class CardPresenter < JSONPresenter
  def initialize(card)
    super(card)
  end

  def card
    object
  end

  def self.safe_json_attributes
    [ :id, :is_tapped, :damage ]
  end

  def extra_json_attributes
    {
      card_type: CardTypePresenter.new(card.card_type).to_safe_json,
      power: card.power,
      toughness: card.toughness,
      remaining_health: card.remaining_health
    }
  end

end
