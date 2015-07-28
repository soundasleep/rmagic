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

  def modify_tags(tags)
    tags
  end

  def until_end_of_turn?
    true
  end

  def effect_id
    self.class.effect_id
  end

  def self.effect_id
    name.split(/[^0-9]/).last.to_i
  end

end
