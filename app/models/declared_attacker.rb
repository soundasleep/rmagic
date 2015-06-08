class DeclaredAttacker < ActiveRecord::Base
  belongs_to :duel
  belongs_to :entity
end
