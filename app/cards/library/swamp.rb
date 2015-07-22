class Library::Swamp < CardType
  include Land

  def name
    "Swamp"
  end

  def mana_provided
    Mana.new black: 1
  end

  def self.metaverse_id
    383410
  end

end
