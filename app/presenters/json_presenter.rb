class JSONPresenter
  attr_reader :object

  def initialize(object)
    @object = object
  end

  def extra_json_attributes(context = nil)
    {}
  end

  def to_json(context = nil)
    object.attributes.select { |k, v| self.class.safe_json_attributes.include?(k.to_sym) }.merge extra_json_attributes(context)
  end

end
