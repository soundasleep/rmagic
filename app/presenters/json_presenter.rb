class JSONPresenter
  attr_reader :object

  def initialize(object)
    @object = object
  end

  def extra_json_attributes
    {}
  end

  def to_safe_json
    object.attributes.select { |k, v| self.class.safe_json_attributes.include?(k.to_sym) }.merge extra_json_attributes
  end

end
