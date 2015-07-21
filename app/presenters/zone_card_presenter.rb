class ZoneCardPresenter < JSONPresenter
  def initialize(object)
    super(object)
  end

  def zone_card
    object
  end

  def safe_json_attributes
    [:id, :card_id ]
  end

  def extra_json_attributes
    {
      card: CardPresenter.new(zone_card.card).to_safe_json
    }
  end

end
