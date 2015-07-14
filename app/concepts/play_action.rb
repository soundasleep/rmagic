class PlayAction < AbstractAction
  def initialize(source:, key:, target: nil)
    super action_type: "play", source: source, key: key, target: target
  end

  def action_description
    "Play"
  end
end
