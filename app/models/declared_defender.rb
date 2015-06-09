class DeclaredDefender < ActiveRecord::Base
  belongs_to :duel
  belongs_to :source, class_name: "Battlefield"
  belongs_to :target, class_name: "DeclaredAttacker"

  validates :duel, presence: true
  validates :source, presence: true
  validates :target, presence: true

end
