class Graveyard < ActiveRecord::Base
  belongs_to :player
  belongs_to :entity
end
