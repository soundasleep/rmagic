class Library
  def card_types
    @card_types ||= load_card_types
  end

  def load_card_types
    cards = Dir[File.dirname(__FILE__) + '/library/*.rb'].map do |file|
      ("Library::" + File.basename(file, ".rb").classify).constantize
    end

    Hash[cards.map { |card| [card.id, card] }]
  end

  def effect_types
    @effect_types ||= load_effect_types
  end

  def load_effect_types
    effects = Dir[File.dirname(__FILE__) + '/effects/*.rb'].map do |file|
      ("Effects::" + File.basename(file, ".rb").classify).constantize
    end

    Hash[effects.map { |effect| [effect.id, effect] }]
  end
end
