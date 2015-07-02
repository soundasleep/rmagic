class StackGraveyardTarget < ActiveRecord::Base
  belongs_to :stack
  belongs_to :target, class_name: "Graveyard"
end
