class CardPresenter < JSONPresenter
  def initialize(card)
    super(card)
  end

  def card
    object
  end

  # TODO rename to json_attributes
  # TODO make instance method
  def self.safe_json_attributes
    [ :id, :is_tapped, :damage ]
  end

  def extra_json_attributes
    fail "no card type for #{card}" unless card.card_type

    {
      card_type: CardTypePresenter.new(card.card_type).to_json,
      power: card.power,
      toughness: card.toughness,
      remaining_health: card.remaining_health,
      controller: format_player(card.controller),
      tags: card.tags,
      enchantments: card.enchantments.map { |c| format_card c }
    }
  end

  private

    def format_card(card)
      CardPresenter.new(card).to_json
    end

    def format_player(player)
      PlayerPresenter.new(player).to_json
    end

end
