class ActionPresenter
  attr_reader :action

  def initialize(action)
    @action = action
  end

  def to_safe_json
    {
      action_type: action.action_type,
      card_id: action.source.card.id,
      source_id: action.source.id,
      key: action.key,
      target_type: action.target_type,
      target_id: action.target ? action.target.id : nil,
      description: action.description
    }
  end

end
