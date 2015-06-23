class CardType
  include ManaHelper

  def to_text
    if is_creature?
      "#{name} (#{power} / #{toughness}) #{cost_string}"
    else
      "#{name} #{cost_string}"
    end
  end

  def action_text(id)
    # just use the key for now
    return "[#{id}]"
  end

  def is_creature?
    false
  end

  def is_land?
    false
  end

  def mana_cost
    {}
  end

  def cost_string
    mana_cost_string(mana_cost)
  end

  def actions
    methods.grep(/^do_/).map{ |m| m[3..-1] } - ["action"]
  end

  # TODO replace 3 arguments with a PossibleAction hash
  def can_do_action?(game_engine, zone_card, index, target = nil)
    send("can_#{index}?", game_engine, zone_card, target)
  end

  # TODO replace 3 arguments with a PossibleAction hash
  def action_cost(game_engine, zone_card, index, target = nil)
    fail "Cannot get cost of 'action'" if index == "action"
    send("#{index}_cost", game_engine, zone_card, target)
  end

  # TODO replace 3 arguments with a PossibleAction hash
  def do_action(game_engine, zone_card, index, target = nil)
    fail "Cannot do 'action'" if index == "action"
    send("do_#{index}", game_engine, zone_card, target)
  end

end
