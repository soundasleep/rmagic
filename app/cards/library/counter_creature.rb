class Library::CounterCreature < Library::Negate
  include Instant

  def name
    "Counter creature"
  end

  def mana_cost
    Mana.new colourless: 1
  end

  def self.metaverse_id
    14
  end

end
