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
    [ :id, :damage ]
  end

  def extra_json_attributes(context = nil)
    fail "no card type for #{card}" unless card.card_type

    {
      card_type: CardTypePresenter.new(card.card_type).to_json,
      power: card.power,
      toughness: card.toughness,
      remaining_health: card.remaining_health,
      controller: format_player(card.controller),
      tags: card.tags,
      enchantments: card.enchantments.map { |c| format_card c, context }
    }
  end

  private

    def format_card(card, context = nil)
      CardPresenter.new(card).to_json(context)
    end

    def format_player(player)
      player == nil ? nil : PlayerPresenter.new(player).to_json
    end

end
