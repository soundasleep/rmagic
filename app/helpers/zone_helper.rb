module ZoneHelper
  def creatures
    select { |zone_card| zone_card.card.card_type.is_creature? }
  end

  def lands
    select { |zone_card| zone_card.card.card_type.is_land? }
  end
end
