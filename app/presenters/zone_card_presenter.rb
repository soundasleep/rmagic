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
    if context != nil && zone_card.is_visible_to?(context)
      {
        id: zone_card.id,
        card_id: zone_card.card_id,
        visible: true,
        card: CardPresenter.new(zone_card.card).to_json(context),
      }
    else
      {
        visible: false,
        card: CardPresenter.new(zone_card.card).to_public_json(context),
      }
    end
  end

end
