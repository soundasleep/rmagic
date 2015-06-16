class CardUniverse
  def find_metaverse(metaverse_id)
    "Library::Metaverse#{metaverse_id}".constantize.new
  end
end
