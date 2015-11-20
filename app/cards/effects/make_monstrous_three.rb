class Effects::MakeMonstrousThree < EffectType
  def name
    "Permanent +3/+3"
  end

  def modify_toughness(n)
    n + 3
  end

  def modify_power(n)
    n + 3
  end

  def self.effect_id
    3
  end

  def until_end_of_turn?
    false
  end

  def modify_tags(tags)
    tags << "monstrous"
    tags
  end

end
