module CollectionsHelper

  def is_first_creature?(collection, card)
    collection.select { |c| c.card.card_type.is_creature? }.first == card
  end

end
