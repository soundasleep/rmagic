class GameActionPresenter
  attr_reader :action

  def initialize(action)
    @action = action
  end

  def to_json
    {
      key: action.key,
      player_id: action.player.id,
      description: action.description
    }
  end

end
