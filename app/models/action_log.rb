class ActionLog < ActiveRecord::Base
  belongs_to :card
  belongs_to :player
  belongs_to :duel

  has_many :targets, class_name: "ActionLogTarget", dependent: :destroy

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
      when "lost"
        "lost"
      when "concede"
        "concedes"
      when "won"
        "won"
      when nil
        "used #{card.action_text card_action} of #{card.to_text}"
      else
        fail "Unknown action #{global_action}"
    end
  end

  # helper methods
  def self.pass_action(duel, player)
    duel.action_logs.create! player: player, global_action: "pass"
  end

  def self.new_turn_action(duel)
    duel.action_logs.create! global_action: "turn", argument: duel.turn
  end

  def self.draw_card_action(duel, player)
    duel.action_logs.create! player: player, global_action: "draw"
  end

  def self.card_action(duel, player, action)
    # TODO action.targets
    self.generic_card_action duel, player, action.source.card, action.key
  end

  def self.defend_card_action(duel, player, zone_card)
    self.generic_card_action duel, player, zone_card.card, "defend"
  end

  def self.declare_card_action(duel, player, zone_card)
    self.generic_card_action duel, player, zone_card.card, "declare"
  end

  def self.attack_card_action(duel, player, zone_card)
    self.generic_card_action duel, player, zone_card.card, "attack"
  end

  def self.defended_card_action(duel, player, zone_card)
    self.generic_card_action duel, player, zone_card.card, "defended"
  end

  def self.graveyard_card_action(duel, player, card)
    self.generic_card_action duel, player, card, "graveyard"
  end

  def self.battlefield_card_action(duel, player, card)
    self.generic_card_action duel, player, card, "battlefield"
  end

  def self.deck_card_action(duel, player, card)
    self.generic_card_action duel, player, card, "deck"
  end

  def self.stack_card_action(duel, player, card)
    self.generic_card_action duel, player, card, "stack"
  end

  def self.effect_action(duel, player, zone_card, effect_id)
    duel.action_logs.create! player: player, card: zone_card.card, card_action: "effect", argument: effect_id
  end

  def self.attach_card_action(duel, player, zone_card, attached_id)
    duel.action_logs.create! player: player, card: zone_card.card, card_action: "attach", argument: attached_id
  end

  private

    def self.generic_card_action(duel, player, card, key)
      duel.action_logs.create! player: player, card: card, card_action: key
    end

end
