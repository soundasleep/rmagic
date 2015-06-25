class EffectType

  def to_text
    "#{name}"
  end

  def modify_power(n)
    n
  end

  def modify_toughness(n)
    n
  end

  def temporary?
    true
  end

  def effect_id
    self.class.name.split(/[^0-9]/).last.to_i
  end

  def self.id
    name.split(/[^0-9]/).last.to_i
  end

end
