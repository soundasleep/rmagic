class Metaverse2 < CardType
  include Land

  def name
    "Forest"
  end

  def mana_provided
    {
      green: 1
    }
  end

end
