module SafeJson
  def extra_json_attributes
    {}
  end

  def safe_json
    attributes.select { |k, v| safe_json_attributes.include?(k.to_sym) }.merge extra_json_attributes
  end

end
