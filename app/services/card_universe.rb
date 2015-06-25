class CardUniverse
  def initialize
    @cache = {}
  end

  def library
    @library ||= Library.new
  end

  def find_metaverse(metaverse_id)
    @cache[metaverse_id] ||= load_card(metaverse_id)
  end

  def load_card(metaverse_id)
    if library.card_types.has_key? metaverse_id
      library.card_types[metaverse_id].new
    else
      false
    end
  end
end
