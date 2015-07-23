class Library::Plains < CardType
  include Land

  def name
    "Plains"
  end

  def mana_provided
    Mana.new white: 1
  end

  def self.metaverse_id
    383346
  end

end
