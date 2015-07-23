class Library::Forest < CardType
  include Land

  def name
    "Forest"
  end

  def mana_provided
    Mana.new green: 1
  end

  def self.metaverse_id
    383241
  end

end
