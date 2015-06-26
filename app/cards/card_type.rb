class CardType
  include ManaHelper

  def to_text
    "#{name} #{cost_string}"
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

  def is_spell?
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

  def can_do_action?(game_engine, action)
    send("can_#{action.key}?", game_engine, action.source, action.target)
  end

  def action_cost(game_engine, action)
    fail "Cannot get cost of 'action'" if action.key == "action"
    send("#{action.key}_cost", game_engine, action.source, action.target)
  end

  def do_action(game_engine, action)
    fail "Cannot do 'action'" if action.key == "action"
    send("do_#{action.key}", game_engine, action.source, action.target)
  end

  def metaverse_id
    self.class.id
  end

  def self.id
    name.split(/[^0-9]/).last.to_i
  end

end
