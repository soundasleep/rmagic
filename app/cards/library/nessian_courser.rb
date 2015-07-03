class Library::NessianCourser < CardType
  include Creature

  def name
    "Nessian Courser"
  end

  def is_creature?
    true
  end

  def power
    3
  end

  def toughness
    3
  end

  def mana_cost
    Mana.new green: 1, colourless: 2
  end

  def self.metaverse_id
    513177
  end

end
