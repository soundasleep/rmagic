class PhaseManager
  def initialize(game_engine)
    @game_engine = game_engine
  end

  def game_engine
    @game_engine
  end

  def total_phases
    duel.total_phases
  end

  def duel
    game_engine.duel
  end

  # The current player has passed the turn; move the priority to the next player if necessary
  def pass!
    # add to action log
    Action.pass_action(duel, duel.priority_player)

    duel.priority_player_number = (duel.priority_player_number % duel.players.count) + 1
    if duel.priority_player_number == duel.current_player_number
      # priority has returned to the current player
      duel.priority_player_number = duel.current_player_number
      duel.phase_number = ((duel.phase_number - 1) % total_phases) + 2

      if duel.phase_number > total_phases
        # next player
        duel.phase_number = 1
        duel.current_player_number = (duel.current_player_number % duel.players.count) + 1
        duel.priority_player_number = duel.current_player_number

        if duel.current_player_number == duel.first_player_number
          # next turn
          duel.turn += 1

          Action.new_turn_action(duel)
        end
      end
    end

    duel.save!

    # perform phase actions
    case duel.phase_number
      when PhaseManager.drawing_phase
        game_engine.draw_phase
      when PhaseManager.playing_phase
        game_engine.play_phase
      when PhaseManager.attacking_phase
        game_engine.attacking_phase
      when PhaseManager.cleanup_phase
        game_engine.cleanup_phase
    end

    # do the AI if necessary
    if duel.priority_player.is_ai?
      SimpleAI.new.do_turn(game_engine, duel.priority_player)
    end
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

end
