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

  # TODO replace with until_end_of_turn? etc
  def temporary?
    true
  end

  # TODO remove and replace with .id
  def effect_id
    self.class.id
  end

  def self.id
    name.split(/[^0-9]/).last.to_i
  end

  def id
    effect_id
  end

end
