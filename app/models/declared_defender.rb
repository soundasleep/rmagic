class DeclaredDefender < ActiveRecord::Base
  belongs_to :duel
  belongs_to :source, class_name: "Battlefield"
  belongs_to :target, class_name: "DeclaredAttacker"
end
