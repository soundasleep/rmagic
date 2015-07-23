class DefendActionPresenter < ActionPresenter

  def to_safe_json
    json = super
    extra = {
      target_card_id: action.target ? action.target.card.id : nil
    }

    json.merge extra
  end

end
