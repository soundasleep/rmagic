class ActionLogTarget < ActiveRecord::Base
  belongs_to :card
  belongs_to :action_log

  def effect_string
    s = card.to_text
    if damage
      s += " causing #{damage} damage"
    end
    s
  end

end
