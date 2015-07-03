class Library::Forest < CardType
  include Land

  def name
    "Forest"
  end

  def mana_provided
    {
      green: 1
    }
  end

  def self.metaverse_id
    2
  end

end
