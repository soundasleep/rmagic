class CardUniverse
  def library
    @library ||= Library.new
  end

  def find_metaverse(metaverse_id)
    if library.card_types.has_key? metaverse_id
      library.card_types[metaverse_id].new
    else
      false
    end
  end
end
