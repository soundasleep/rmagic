class Entity < ActiveRecord::Base
  def to_text
    return "(metaverse #{metaverse_id})" if metaverse_id
    return "(unknown)"
  end
end
