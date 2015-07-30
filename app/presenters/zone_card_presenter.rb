class ZoneCardPresenter < JSONPresenter
  def initialize(object)
    super(object)
  end

  def zone_card
    object
  end

  def self.safe_json_attributes
    [:id, :card_id ]
  end

  def extra_json_attributes
    {
      card: CardPresenter.new(zone_card.card).to_json,
      visible: true
    }
  end

  def to_hidden_json
    {
      id: zone_card.id,
      card: CardPresenter.new(zone_card.card).to_hidden_json,
      visible: false,
    }
  end

end
