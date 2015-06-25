class Player < ActiveRecord::Base
  include ManaHelper

  has_many :deck, dependent: :destroy
  has_many :hand, dependent: :destroy
  has_many :battlefield, dependent: :destroy
  has_many :graveyard, dependent: :destroy

  validates :life, :name, :mana_blue, :mana_green,
      :mana_red, :mana_white, :mana_black,
      :mana_colourless, presence: true

  before_validation :init

  def init
    self.life ||= 20
    self.name ||= "Player"
    self.is_ai ||= false
    self.mana_blue ||= 0
    self.mana_green ||= 0
    self.mana_red ||= 0
    self.mana_white ||= 0
    self.mana_black ||= 0
    self.mana_colourless ||= 0
  end

  def zones
    [ deck, hand, battlefield, graveyard ]
  end

  def mana
    mana_cost_string mana_pool
  end

  def clear_mana!
    set_mana! zero_mana
  end

  def set_mana!(mana)
    self.mana_green = mana[:green]
    self.mana_blue = mana[:blue]
    self.mana_red = mana[:red]
    self.mana_white = mana[:white]
    self.mana_black = mana[:black]
    self.mana_colourless = mana[:colourless]
    self.save!
  end

  def mana_pool
    {
      green: mana_green,
      blue: mana_blue,
      red: mana_red,
      white: mana_red,
      black: mana_black,
      colourless: mana_colourless
    }
  end

  def has_mana?(cost)
    cost = zero_mana.merge(cost)
    pool = mana_pool

    use_mana_from_pool(cost, pool).present?
  end

  def use_mana!(cost)
    cost = zero_mana.merge(cost)
    pool = mana_pool

    result = use_mana_from_pool(cost, pool)
    fail "Could not use mana #{cost} from #{pool}" unless result

    set_mana! result
  end

  def add_mana!(cost)
    cost = zero_mana.merge(cost)
    pool = mana_pool

    set_mana! add_mana_to_pool(cost, pool)
  end

  def add_life!(n)
    update! life: life + n
  end

  def remove_life!(n)
    update! life: life - n
  end

  # TODO move these into a (testable) helper?
  def battlefield_creatures
    select_creatures battlefield
  end

  def battlefield_lands
    select_lands battlefield
  end

  def hand_creatures
    select_creatures hand
  end

  def hand_lands
    select_lands hand
  end

  def graveyard_creatures
    select_creatures graveyard
  end

  def graveyard_lands
    select_lands graveyard
  end

  def select_creatures(collection)
    collection.select { |b| b.card.card_type.is_creature? }
  end

  def select_lands(collection)
    collection.select { |b| b.card.card_type.is_land? }
  end

  def next_graveyard_order
    return 1 if graveyard.empty?
    graveyard.map(&:order).max + 1
  end

  def next_deck_order
    return 1 if deck.empty?
    deck.map(&:order).max + 1
  end

  def is_card?
    false
  end

  def is_player?
    true
  end

  def to_text
    "Player #{name}"
  end

end
