class Library
  class NoSuchCardError < StandardError; end

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

    Hash[cards.map { |card| [card.metaverse_id, card] }]
  end

  def find_card(name)
    card_types.values.each do |card_type|
      return card_type if card_type.new.name == name
    end
    raise NoSuchCardError, "Could not find any card called '#{name}'"
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

    Hash[effects.map { |effect| [effect.effect_id, effect] }]
  end

  def duplicates(collection)
    collection.detect { |e| collection.rindex(e) != collection.index(e) }
  end

  def duplicate_metaverses(collection)
    duplicates(collection.map(&:metaverse_id))
  end

  def duplicate_effects(collection)
    duplicates(collection.map(&:effect_id))
  end

end
