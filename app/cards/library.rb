class Library
  def card_types
    @card_types ||= load_card_types
  end

  def load_card_types
    cards = Dir[File.dirname(__FILE__) + '/library/*.rb'].map do |file|
      constant_name = "Library::" + File.basename(file, ".rb").camelize
      begin
        constant_name.constantize
      rescue NameError
        fail "Could not load #{file} into #{constant_name}"
      end
    end

    fail("Found duplicate card type ID #{duplicates(cards)}") if duplicates(cards)

    Hash[cards.map { |card| [card.id, card] }]
  end

  def effect_types
    @effect_types ||= load_effect_types
  end

  def load_effect_types
    effects = Dir[File.dirname(__FILE__) + '/effects/*.rb'].map do |file|
      constant_name = "Effects::" + File.basename(file, ".rb").camelize
      begin
        constant_name.constantize
      rescue NameError
        fail "Could not load #{file} into #{constant_name}"
      end
    end

    fail("Found duplicate effect type ID #{duplicates(effects)}") if duplicates(effects)

    Hash[effects.map { |effect| [effect.id, effect] }]
  end

  def duplicates(collection)
    ids = collection.map(&:id)
    ids.detect { |e| ids.rindex(e) != ids.index(e) }
  end
end
