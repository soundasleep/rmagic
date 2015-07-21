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

end
