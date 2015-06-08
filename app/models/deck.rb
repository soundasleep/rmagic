class Deck < ActiveRecord::Base
  belongs_to :player
  belongs_to :entity

  validates :player, presence: true
  validates :entity, presence: true

  validates :entity, uniqueness: true
end
