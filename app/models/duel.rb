class Duel < ActiveRecord::Base
  belongs_to :player1, class_name: "Player"
  belongs_to :player2, class_name: "Player"

  after_initialize :init

  def init
    self.turn ||= 1
    self.first_player ||= 1
    self.current_player ||= 1
    self.priority_player ||= 1
    self.phase ||= 1
  end

  def actions
    Action.where(duel: self).order(created_at: :desc).first(5)
  end

  def players
    [ player1, player2 ]
  end

  def total_phases
    # TODO fix up as necessary
    4
  end

  def active_player
    players[priority_player - 1]
  end

  def current_player_player
    players[current_player - 1]
  end

  # The current player has passed the turn; move the priority to the next player if necessary
  def pass
    # add to action log
    Action.pass_action(self, active_player)

    self.priority_player = (priority_player % players.count) + 1
    if priority_player == current_player
      # priority has returned to the current player
      self.priority_player = current_player
      self.phase = ((phase - 1) % total_phases) + 2

      if phase > total_phases
        # next player
        self.phase = 1
        self.current_player = (current_player % players.count) + 1
        self.priority_player = current_player

        if current_player == first_player
          # next turn
          self.turn += 1

          Action.new_turn_action(self)
        end
      end
    end

    save!

    # perform phase actions
    case phase
      when Duel.drawing_phase
        game_engine.draw_phase
      when Duel.playing_phase
        game_engine.play_phase
      when Duel.attack_phase
        game_engine.attack_phase
      when Duel.cleanup_phase
        game_engine.cleanup_phase
    end

    # do the AI if necessary
    if active_player.is_ai?
      SimpleAI.new.do_turn(self)
    end
  end

  def game_engine
    GameEngine.new(self)
  end

  def self.drawing_phase
    1
  end

  def self.playing_phase
    2
  end

  def self.attack_phase
    3
  end

  def self.cleanup_phase
    4
  end

end
