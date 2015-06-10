class Duel < ActiveRecord::Base
  belongs_to :player1, class_name: "Player"
  belongs_to :player2, class_name: "Player"

  has_many :declared_attackers, dependent: :destroy
  has_many :declared_defenders, dependent: :destroy
  has_many :actions, dependent: :destroy

  after_initialize :init

  def init
    self.turn ||= 1
    self.first_player_number ||= 1
    self.current_player_number ||= 1
    self.priority_player_number ||= 1
    self.phase_number ||= 1
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

  def total_phases
    4
  end

  def phase_text
    case phase_number
      when PhaseManager.drawing_phase
        "drawing phase: draw cards"
      when PhaseManager.playing_phase
        "playing phase: play cards, cast creatures"
      when PhaseManager.attacking_phase
        "attack phase: declare attackers and defenders"
      when PhaseManager.cleanup_phase
        "cleanup phase: damage happens, cleanup destroyed cards"
    end
  end

  def current_turn_text
    "Turn #{turn}, phase #{phase_number} (#{phase_text}), current player #{current_player_number}, priority player #{priority_player_number}"
  end

end
