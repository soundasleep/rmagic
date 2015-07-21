class ActionLogTargetPresenter < JSONPresenter
  def initialize(target)
    super(target)
  end

  def target
    object
  end

  def self.safe_json_attributes
    [ :card_id, :action_log_id, :damage ]
  end

end
