class StackPlayerTarget < ActiveRecord::Base
  belongs_to :stack
  belongs_to :target, class_name: "Player"
end
