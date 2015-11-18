class Effects::AddOneToughness < EffectType
  def name
    "Permanent +0/+1"
  end

  def modify_toughness(n)
    n + 1
  end

  def self.effect_id
    2
  end

  def until_end_of_turn?
    false
  end
end
