module ActionableController

  def find_target
    case params[:target_type]
      when "player"
        Player.find(params[:target])
      when "battlefield"
        Battlefield.find(params[:target])
      when "none"
        nil
      else
        fail "Unknown target type '#{params[:target_type]}'"
    end
  end

  def get_target_type(target)
    return "none" if target == nil
    case target.class.name
      when "Player"
        "player"
      when "Battlefield"
        "battlefield"
      else
        fail "Unknown target type '#{target.class.name}'"
    end
  end

end
