class StackTargetPresenter < JSONPresenter
  def initialize(target)
    super(target)
  end

  def target
    object
  end

  def self.safe_json_attributes
    [ :target_id ]
  end

end
