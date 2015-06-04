class Duel < ActiveRecord::Base
  belongs_to :player1, class_name: "Player"
  belongs_to :player2, class_name: "Player"

  def initialize(attr = {})
    attr[:turn] ||= 1
    attr[:first_player] ||= 1
    attr[:current_player] ||= 1
    attr[:priority_player] ||= 1
    attr[:phase] ||= 1
    super(attr)
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
    players[self.priority_player - 1]
  end

  # The current player has passed the turn; move the priority to the next player if necessary
  def pass
    # add to action log
    Action.pass_action(self, active_player).save

    self.priority_player = (self.priority_player % players.count) + 1
    if self.priority_player == self.current_player
      # priority has returned to the current player
      self.priority_player = self.current_player
      self.phase = ((self.phase - 1) % total_phases) + 2

      if self.phase > total_phases
        # next player
        self.phase = 1
        self.current_player = (self.current_player % players.count) + 1
        self.priority_player = self.current_player

        if self.current_player == self.first_player
          # next turn
          self.turn += 1

          Action.new_turn_action(self).save
        end
      end
    end

    # do the AI if necessary
    if self.priority_player == 2
      SimpleAI.new.do_turn(self)
    end
  end
end
