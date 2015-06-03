class Action < ActiveRecord::Base
  belongs_to :entity
  belongs_to :player
  belongs_to :duel

  def targets
    ActionTarget.where({action: self})
  end

  def action_text
    entity.action_text entity_action
  end
end
