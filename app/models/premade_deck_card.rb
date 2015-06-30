class PremadeDeckCard < ActiveRecord::Base
  belongs_to :premade_deck

  def card_type
    @card ||= card_universe.find_metaverse(metaverse_id)
  end

  private
    def card_universe
      @card_universe ||= CardUniverse.new
    end

end
