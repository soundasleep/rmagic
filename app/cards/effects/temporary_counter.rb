class Effects::TemporaryCounter < EffectType
  def name
    "Temporary counter"
  end

  def modify_power(n)
    n + 1
  end

  def modify_toughness(n)
    n + 1
  end

  def self.effect_id
    1
  end

end
