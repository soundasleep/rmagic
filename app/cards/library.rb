class Library
  def card_types
    @card_types ||= load_card_types
  end

  def load_card_types
    cards = Dir[File.dirname(__FILE__) + '/library/*.rb'].map do |file|
      ("Library::" + File.basename(file, ".rb").classify).constantize.new
    end

    Hash[cards.map { |card| [card.metaverse_id, card] }]
  end
end
