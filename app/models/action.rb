class Action < ActiveRecord::Base
  belongs_to :entity
  belongs_to :player
  belongs_to :duel

  def targets
    ActionTarget.where({action: self})
  end
end
