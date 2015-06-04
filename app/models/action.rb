class Action < ActiveRecord::Base
  belongs_to :entity
  belongs_to :player
  belongs_to :duel

  def targets
    ActionTarget.where({action: self})
  end

  def action_text
    case global_action
    when "pass"
      return "passes"
    when "turn"
      return "Turn #{argument} started"
    when "draw"
      return "draws a card"
    when "play"
      return "plays #{entity.to_text}"
    when nil
    else
      fail "Unknown action #{global_action}"
    end

    return "used #{entity.action_text entity_action} of #{entity.to_text}"
  end

  # helper methods
  def self.pass_action(duel, player)
    Action.create( player: player, duel: duel, global_action: "pass" )
  end

  def self.new_turn_action(duel)
    Action.create( duel: duel, global_action: "turn", argument: duel.turn )
  end

  def self.draw_card_action(duel, player)
    Action.create( player: player, duel: duel, global_action: "draw" )
  end

  def self.play_card_action(duel, player, entity)
    Action.create( player: player, duel: duel, entity: entity, global_action: "play")
  end
end
