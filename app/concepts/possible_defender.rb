class PossibleDefender < PossibleAction
  def initialize(source:, target: nil)
    super action_type: "defend", source: source, key: "defend", target: target
  end

  def action_description
    "Declare defender"
  end
end
