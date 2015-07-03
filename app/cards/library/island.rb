class Library::Island < CardType
  include Land

  def name
    "Island"
  end

  def mana_provided
    {
      blue: 1
    }
  end

  def self.metaverse_id
    11
  end

end
