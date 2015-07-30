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

  def extra_json_attributes(context = nil)
    if zone_card.is_visible_to?(context)
      {
        visible: true,
        is_tapped: zone_card.card.is_tapped,
        card: CardPresenter.new(zone_card.card).to_json(context),
      }
    else
      {
        visible: false,
        is_tapped: zone_card.card.is_tapped,
      }
    end
  end

end
