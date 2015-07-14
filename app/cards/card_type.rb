class CardType
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

  def is_instant?
    false
  end

  def is_enchantment?
    false
  end

  def playing_goes_onto_stack?(key)
    send("playing_#{key}_goes_onto_stack?")
  end

  def mana_cost
    Mana.new
  end

  def cost_string
    mana_cost.to_s
  end

  def actions
    methods.grep(/^(do)_/).map{ |m| m["do_".length..-1] } - ["action"]
  end

  def conditions_for(action_key)
    # TODO should this be renamed to conditions_for_KEY?
    send("can_#{action_key}?")
  end

  def can_do_action?(duel, action)
    conditions_for(action.key).send(:evaluate, duel, action)
  end

  def action_cost(action_key)
    send("#{action_key}_cost")
  end

  def actions_for(action_key)
    # TODO should this be renamed to actions_for_KEY?
    send("do_#{action_key}")
  end

  def do_action(duel, action)
    if playing_goes_onto_stack?(action.key)
      executor = PutOntoStack.new
    else
      executor = actions_for(action.key)
    end

    executor.send(:execute, duel, action)
  end

  def resolve_action(duel, stack)
    actions_for(stack.key).send(:execute, duel, stack)
  end

  def metaverse_id
    self.class.metaverse_id
  end

  def self.metaverse_id
    name.split(/[^0-9]/).last.to_i
  end

end
