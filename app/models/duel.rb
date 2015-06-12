class Duel < ActiveRecord::Base
  belongs_to :player1, class_name: "Player"
  belongs_to :player2, class_name: "Player"

  has_many :declared_attackers, dependent: :destroy
  has_many :declared_defenders, dependent: :destroy
  has_many :actions, dependent: :destroy

  enum phase_number: [ :drawing_phase, :playing_phase, :attacking_phase, :cleanup_phase ]

  after_initialize :init

  def init
    self.turn ||= 1
    self.first_player_number ||= 1
    self.current_player_number ||= 1
    self.priority_player_number ||= 1
    self.phase_number ||= :drawing_phase
  end

  def last_actions
    actions.order(created_at: :desc)
  end

  def players
    [ player1, player2 ]
  end

  def other_player
    if current_player == player1 then player2 else player1 end
  end

  def priority_player
    players[priority_player_number - 1]
  end

  def current_player
    players[current_player_number - 1]
  end

  # TODO remove
  def total_phases
    4
  end

  def phase
    phase_number.to_sym
  end

  def next_phase!
    next_player = false
    self.phase_number = case phase
      when :drawing_phase
        :playing_phase
      when :playing_phase
        :attacking_phase
      when :attacking_phase
        :cleanup_phase
      when :cleanup_phase
        next_player = true
        :drawing_phase
      else
        fail "Unknown phase '#{phase}'"
    end
    save!
    return next_player
  end

  def phase_text
    case phase
      when :drawing_phase
        "drawing phase: draw cards"
      when :playing_phase
        "playing phase: play cards, cast creatures"
      when :attacking_phase
        "attack phase: declare attackers and defenders"
      when :cleanup_phase
        "cleanup phase: damage happens, cleanup destroyed cards"
      else
        fail "Unknown phase '#{phase}'"
    end
  end

  def current_turn_text
    "Turn #{turn}, phase #{phase} (#{phase_text}), current player #{current_player_number}, priority player #{priority_player_number}"
  end

end
