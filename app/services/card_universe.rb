class CardUniverse
  def find_metaverse(metaverse_id)
    begin
      "Library::Metaverse#{metaverse_id}".constantize.new
    rescue NameError
      # TODO replace with a library that defines a range of valid card types
      false
    end
  end
end
