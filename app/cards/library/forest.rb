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

  def metaverse_id
    2
  end

  def self.id
    2
  end

end
