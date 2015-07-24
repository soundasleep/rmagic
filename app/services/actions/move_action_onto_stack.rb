class MoveActionOntoStack
  attr_reader :duel, :action

  def initialize(duel:, action:)
    @duel = duel
    @action = action
  end

  def call
    RemoveCardFromAllZones.new(duel: duel, player: player, card: card).call or fail "Could not remove card"

    # update log
    ActionLog.stack_card_action(duel, player, card)

    # move to stack
    stack = duel.stack.create! card: card, player: player, order: duel.next_stack_order, key: action_key

    if target
      if target.has_zone?
        if target.zone.is_battlefield?
          stack.battlefield_targets.create! target: target
        elsif target.zone.is_graveyard?
          stack.graveyard_targets.create! target: target
        else
          fail "Unknown target zone #{target.zone}"
        end
      else
        stack.player_targets.create! target: target
      end
    end

    true
  end

  private

    def player
      action.source.player
    end

    def card
      action.source.card
    end

    def action_key
      action.key
    end

    def target
      action.target
    end
end
