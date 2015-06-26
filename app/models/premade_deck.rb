class PremadeDeck < ActiveRecord::Base
  belongs_to :created_by, class_name: "User"

  has_many :cards, dependent: :destroy, class_name: "PremadeDeckCard"
end
