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

  def total_phases
    # TODO fix up as necessary
    4
  end

  def priority_player
    players[priority_player_number - 1]
  end

  def current_player
    players[current_player_number - 1]
  end

  # The current player has passed the turn; move the priority to the next player if necessary
  # TODO move into game_engine?
  def pass
    # add to action log
    Action.pass_action(self, priority_player)

    self.priority_player_number = (priority_player_number % players.count) + 1
    if priority_player_number == current_player_number
      # priority has returned to the current player
      self.priority_player_number = current_player_number
      self.phase_number = ((phase_number - 1) % total_phases) + 2

      if phase_number > total_phases
        # next player
        self.phase_number = 1
        self.current_player_number = (current_player_number % players.count) + 1
        self.priority_player_number = current_player_number

        if current_player_number == first_player_number
          # next turn
          self.turn += 1

          Action.new_turn_action(self)
        end
      end
    end

    save!

    # perform phase actions
    case phase_number
      when Duel.drawing_phase
        game_engine.draw_phase
      when Duel.playing_phase
        game_engine.play_phase
      when Duel.attacking_phase
        game_engine.attacking_phase
      when Duel.cleanup_phase
        game_engine.cleanup_phase
    end

    # do the AI if necessary
    if priority_player.is_ai?
      SimpleAI.new.do_turn(self)
    end
  end

  def game_engine
    GameEngine.new(self)
  end

  # TODO consider replacing with symbols
  def self.drawing_phase
    1
  end

  def self.playing_phase
    2
  end

  def self.attacking_phase
    3
  end

  def self.cleanup_phase
    4
  end

  def phase_text
    case phase_number
      when Duel.drawing_phase
        "drawing phase: draw cards"
      when Duel.playing_phase
        "playing phase: play cards, cast creatures"
      when Duel.attacking_phase
        "attack phase: declare attackers and defenders"
      when Duel.cleanup_phase
        "cleanup phase: damage happens, cleanup destroyed cards"
    end
  end

  def current_turn_text
    "Turn #{turn}, phase #{phase_number} (#{phase_text}), current player #{current_player_number}, priority player #{priority_player_number}"
  end

end
