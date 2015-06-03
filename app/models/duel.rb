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
    Action.where(duel: self)
  end

  def players
    [ player1, player2 ]
  end

  def total_phases
    # TODO fix up as necessary
    4
  end

  # The current player has passed the turn; move the priority to the next player if necessary
  def pass
    self.priority_player = (self.priority_player % players.count) + 1
    if self.priority_player == self.current_player
      self.priority_player = self.first_player
      self.phase = (self.phase % total_phases) + 1
      if self.phase == total_phases + 1
        self.phase = 1
        self.current_player = (self.current_player % players.count) + 1
        if (self.current_player == self.first_player)
          self.turn += 1
        end
      end
    end
  end
end
