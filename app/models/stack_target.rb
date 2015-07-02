class StackTarget < ActiveRecord::Base
  belongs_to :stack
  belongs_to :target, class_name: "Battlefield"
end
