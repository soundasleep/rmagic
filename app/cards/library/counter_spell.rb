class Library::CounterSpell < Library::Negate
  include Instant

  def name
    "Counter spell"
  end

  def mana_cost
    Mana.new colourless: 1
  end

  def self.metaverse_id
    15
  end

end
