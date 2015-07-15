class DuelRequest < ActiveRecord::Base
  belongs_to :user
  belongs_to :premade_deck
end
