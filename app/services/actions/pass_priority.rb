class PassPriority
  attr_reader :duel

  def initialize(duel:)
    @duel = duel
  end

  def call
    # check for winners when entering a phase
    CheckGameForWinners.new(duel: duel).call

    if duel.is_finished?
      # nothing left to do
      return true
    end

    # The current player has passed the turn; move the priority to the next player if necessary
    previous_phase = duel.phase

    # add to action log
    ActionLog.pass_action(duel, duel.priority_player)

    duel.update priority_player_number: (duel.priority_player_number % duel.players.count) + 1

    if duel.priority_player_number == duel.current_player_number
      # priority has returned to the current player
      duel.update priority_player_number: duel.current_player_number
      next_player = duel.next_phase!

      if next_player
        if previous_phase.for_each_player?
          duel.update current_player_number: (duel.current_player_number % duel.players.count) + 1
          duel.update priority_player_number: duel.current_player_number
        end

        # TODO maybe move this into a service (current player has changed/increment current player)
        duel.action_logs.create! global_action: "current_player", player: duel.current_player

        if duel.phase.increments_turn? && duel.current_player_number == duel.first_player_number
          # next turn
          duel.update turn: duel.turn + 1

          # add to action log
          ActionLog.new_turn_action(duel)
        end
      end
    end

    # update the last time somebody passed
    duel.update last_pass: Time.now

    # apply changes to reduce duel.after_update callbacks
    duel.save!

    # things that happen at the end of every single pass
    RemoveUnattachedEnchantments.new(duel: duel).call

    if duel.phase != previous_phase
      # TODO maybe move this (enter_phase!) into a service
      duel.action_logs.create! global_action: "enter_phase", phase_number: duel.phase.to_sym

      duel.enter_phase!
    end

    # do the AI if necessary
    if duel.priority_player.is_ai?
      SimpleAI.new.do_turn(duel, duel.priority_player)
    end

    true
  end

end
