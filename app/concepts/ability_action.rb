class AbilityAction < AbstractAction
  def initialize(source:, key:, target: nil)
    super action_type: "ability", source: source, key: key, target: target
  end

  def action_description
    "Use ability"
  end
end
