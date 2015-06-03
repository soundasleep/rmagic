class CardUniverse
  def find_metaverse(metaverse_id)
    "Metaverse#{metaverse_id}".constantize.new
  end
end
