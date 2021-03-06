class Duel < ActiveRecord::Base
  include Phases

  belongs_to :player1, class_name: "Player"
  belongs_to :player2, class_name: "Player"

  has_many :declared_attackers, dependent: :destroy
  has_many :declared_defenders, dependent: :destroy
  has_many :action_logs, dependent: :destroy
  has_many :stack, dependent: :destroy

  validates :player1, :player2, :turn, :first_player_number,
      :current_player_number, :priority_player_number,
      :phase_number, presence: true

  # TODO use on_create instead
  # TODO make this method private
  # TODO rename :init to :set_default_phase
  before_validation :init

  def init
    self.phase_number ||= :mulligan_phase
  end

  def players
    [ player1, player2 ]
  end

  def other_player
    current_player == player1 ? player2 : player1
  end

  def priority_player
    players[priority_player_number - 1]
  end

  def current_player
    players[current_player_number - 1]
  end

  def first_player
    players[first_player_number - 1]
  end

  def reset_priority!
    update! priority_player_number: current_player_number
  end

  def next_phase!
    update! phase_number: phase.next_phase.to_sym
    return phase.changes_player?
  end

  def enter_phase!
    phase.enter_phase_service.new(duel: self).call
  end

  # TODO rename order to position/etc
  def next_stack_order
    return 1 if stack.empty?
    stack.map(&:order).max + 1
  end

  def title
    "#{player1.name} (#{player1.life}) v #{player2.name} (#{player2.life})"
  end

  def zones
    [ stack ]
  end

  def is_finished?
    finished_phase?
  end

  def winners
    if is_finished?
      players.select{ |p| p.won? }
    else
      nil
    end
  end

  def losers
    if is_finished?
      players.select{ |p| p.lost? }
    else
      nil
    end
  end

  def drawers
    if is_finished?
      players.select{ |p| !(p.won? || p.lost?) }
    else
      nil
    end
  end

  # TODO move to top
  after_update :update_duel_channels

  # TODO move servicey methods to the top
  # TODO look at moving this out of all models, and instead doing it all in the services?
  def update_duel_channels
    UpdateDuelChannels.new(duel: self).call
  end
end
