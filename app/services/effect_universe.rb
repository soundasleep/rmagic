class EffectUniverse
  def initialize
    @cache = {}
  end

  def library
    @library ||= Library.new
  end

  def find_effect(effect_id)
    @cache[effect_id.to_i] ||= load_effect(effect_id.to_i)
  end

  def load_effect(effect_id)
    if library.effect_types.has_key? effect_id
      library.effect_types[effect_id].new
    else
      false
    end
  end

  def all
    library.effect_types.values
  end
end
