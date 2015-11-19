class Library::ReclamationSage < CardType
  include Creature

  def name
    "Reclamation Sage"
  end

  def power
    2
  end

  def toughness
    1
  end

  def mana_cost
    Mana.new colourless: 1, green: 2
  end

  def self.metaverse_id
    389651
  end

end
