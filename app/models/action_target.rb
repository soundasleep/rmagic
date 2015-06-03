class ActionTarget < ActiveRecord::Base
  belongs_to :entity
  belongs_to :action

  def effect_string
    s = entity.to_text
    if damage
      s += " causing #{damage} damage"
    end
    s
  end
end
