class DefenderAction < AbstractAction
  def initialize(source:, target: nil)
    super action_type: "defend", source: source, key: "defend", target: target
  end

  def action_description
    "Defend"
  end

  def description
    "#{action_description}#{target_text}"
  end

  def declare(duel)
    DeclareDefender.new(duel: duel, defend: self).call
  end
end
