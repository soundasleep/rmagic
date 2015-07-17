class ActionLogTarget < ActiveRecord::Base
  include SafeJson

  belongs_to :card
  belongs_to :action_log

  def effect_string
    s = card.to_text
    if damage
      s += " causing #{damage} damage"
    end
    s
  end

  def safe_json_attributes
    [ :id, :card_id, :damage ]
  end

  def extra_json_attributes
    {
      effect_string: effect_string
    }
  end

end
