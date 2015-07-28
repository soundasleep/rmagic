module Enchantment
  include Tappable

  def is_enchantment?
    true
  end

  def is_spell?
    true
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

end
