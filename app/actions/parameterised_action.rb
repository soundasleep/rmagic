class ParameterisedAction < Action
  attr_reader :x

  def initialize(x:)
    @x = x.to_i
  end

  def describe
    # TODO this should probably be / x /
    super.gsub(/x/, @x.to_s)
  end
end
