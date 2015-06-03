class Entity < ActiveRecord::Base
  def to_text
    if metaverse_id
      # card_type = Universe.instance.get_metaverse(metaverse_id)
      # return card_type.new.to_text if card_type
      card_type = CardUniverse.new.find_metaverse(metaverse_id)
      return card_type.to_text if card_type
    end

    return "(metaverse #{metaverse_id})" if metaverse_id
    return "(unknown)"
  end
end
