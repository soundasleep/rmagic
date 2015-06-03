class ActionTarget < ActiveRecord::Base
  belongs_to :entity
  belongs_to :action
end
