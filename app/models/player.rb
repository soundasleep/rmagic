class Player < ActiveRecord::Base
  include SafeJson
  include Subscribable

  has_many :deck, -> { order(order: :desc) }, dependent: :destroy
  has_many :hand, dependent: :destroy
  has_many :battlefield, dependent: :destroy
  has_many :graveyard, -> { order(order: :desc) }, dependent: :destroy

  has_one :user

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
    mana_pool.to_s
  end

  def clear_mana!
    set_mana! Mana.new
  end

  def set_mana!(mana)
    update!({
      mana_green: mana.green,
      mana_blue: mana.blue,
      mana_red: mana.red,
      mana_white: mana.white,
      mana_black: mana.black,
      mana_colourless: mana.colourless
    })
  end

  def mana_pool
    Mana.new({
      green: mana_green,
      blue: mana_blue,
      red: mana_red,
      white: mana_red,
      black: mana_black,
      colourless: mana_colourless
    })
  end

  def has_mana?(cost)
    mana_pool.use(cost).present?
  end

  def use_mana!(cost)
    result = mana_pool.use(cost)
    fail "Could not use mana #{cost} from #{pool}" unless result

    set_mana! result
  end

  def add_mana!(cost)
    result = mana_pool.add(cost)

    set_mana! result
  end

  def add_life!(n)
    update! life: life + n
  end

  def remove_life!(n)
    update! life: life - n
  end

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

  def has_zone?
    false
  end

  def duel
    Duel.where("player1_id=? OR player2_id=?", id, id).first!
  end

  def safe_json_attributes
    [ :id, :name, :mana, :life ]
  end

  def extra_json_attributes
    {
      mana: mana_pool.to_hash,
      mana_string: mana
    }
  end

  def all_actions_json
    {
      play: action_finder.playable_cards(self).map(&:safe_json),
      ability: action_finder.ability_cards(self).map(&:safe_json),
      defend: action_finder.defendable_cards(self).map(&:safe_json),
      attack: action_finder.available_attackers(self).map(&:safe_json),
      game: action_finder.game_actions(self).map(&:safe_json)
    }
  end

  after_update :update_action_channels
  after_update :update_zone_channels

  def update_action_channels(source = nil)
    json = self.all_actions_json
    if source
      json[:source] = source
    end

    # trigger an update on all channels
    WebsocketRails["actions/#{id}"].trigger "update", json
  end

  def update_zone_channels(source = nil)
    update_deck_channels(source)
    update_battlefield_channels(source)
    update_hand_channels(source)
    update_graveyard_channels(source)
  end

  def deck_json
    {
      deck: deck.map(&:safe_json)
    }
  end

  def battlefield_json
    {
      battlefield: battlefield.map(&:safe_json)
    }
  end

  def hand_json
    {
      hand: hand.map(&:safe_json)
    }
  end

  def graveyard_json
    {
      graveyard: graveyard.map(&:safe_json)
    }
  end

  private

    def action_finder
      @action_finder ||= ActionFinder.new(duel)
    end

    def update_channel(channel, json, source = nil)
      if source
        json[:source] = source
      end

      # trigger an update on all channels
      WebsocketRails[channel].trigger "update", json
    end

    def update_deck_channels(source = nil)
      update_channel "deck/#{id}", deck_json, source
    end

    def update_battlefield_channels(source = nil)
      update_channel "battlefield/#{id}", battlefield_json, source
    end

    def update_hand_channels(source = nil)
      update_channel "hand/#{id}", hand_json, source
    end

    def update_graveyard_channels(source = nil)
      update_channel "graveyard/#{id}", graveyard_json, source
    end

end
