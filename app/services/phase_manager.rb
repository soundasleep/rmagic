# TODO move this into the PassPriority service instead
class PhaseManager
  attr_reader :duel

  def initialize(duel)
    @duel = duel
  end

  # The current player has passed the turn; move the priority to the next player if necessary
  def pass!
    previous_phase = duel.phase

    # add to action log
    ActionLog.pass_action(duel, duel.priority_player)

    duel.update! priority_player_number: (duel.priority_player_number % duel.players.count) + 1
    if duel.priority_player_number == duel.current_player_number
      # priority has returned to the current player
      duel.update! priority_player_number: duel.current_player_number
      next_player = duel.next_phase!

      if next_player
        duel.update! current_player_number: (duel.current_player_number % duel.players.count) + 1
        duel.update! priority_player_number: duel.current_player_number

        if duel.current_player_number == duel.first_player_number
          # next turn
          duel.update! turn: duel.turn + 1

          # add to action log
          ActionLog.new_turn_action(duel)
        end
      end
    end

    if duel.phase != previous_phase
      duel.phase.enter_phase_service.new(duel: duel).call
    end

    # do the AI if necessary
    if duel.priority_player.is_ai?
      SimpleAI.new.do_turn(duel, duel.priority_player)
    end
  end

end
