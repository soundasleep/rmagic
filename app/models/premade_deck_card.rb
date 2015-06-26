class PremadeDeckCard < ActiveRecord::Base
  belongs_to :premade_deck

  def card_type
    @card ||= CardUniverse.new.find_metaverse(metaverse_id)
  end
end
