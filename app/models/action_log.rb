class ActionLog < ActiveRecord::Base
  belongs_to :card
  belongs_to :player
  belongs_to :duel

  has_many :targets, class_name: "ActionLogTarget"

  validate :global_action_or_card

  def global_action_or_card
    if !global_action && !card
      errors.add(:card, "No card defined for a non-global action")
    end
  end

  def action_text
    case global_action
    when "pass"
      "passes"
    when "turn"
      "Turn #{argument} started"
    when "draw"
      "draws a card"
    when "play"
      "plays #{card.to_text}"
    when nil
      "used #{card.action_text card_action} of #{card.to_text}"
    else
      fail "Unknown action #{global_action}"
    end
  end

  # helper methods
  def self.pass_action(duel, player)
    ActionLog.create!( player: player, duel: duel, global_action: "pass" )
  end

  def self.new_turn_action(duel)
    ActionLog.create!( duel: duel, global_action: "turn", argument: duel.turn )
  end

  def self.draw_card_action(duel, player)
    ActionLog.create!( player: player, duel: duel, global_action: "draw" )
  end

  def self.card_action(duel, player, card, key)
    ActionLog.create!( player: player, duel: duel, card: card, card_action: key)
  end
end
