class User < ActiveRecord::Base
  has_many :premade_decks, dependent: :destroy, foreign_key: :created_by_id

  has_many :players, dependent: :destroy
end
