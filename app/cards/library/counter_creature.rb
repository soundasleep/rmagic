class Library::CounterCreature < Library::Negate
  def name
    "Counter creature"
  end

  def is_instant?
    true
  end

  def mana_cost
    Mana.new colourless: 1
  end

  def self.metaverse_id
    14
  end

end
