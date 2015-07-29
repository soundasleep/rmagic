class CardType
  def to_text
    name
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

  def power
    0
  end

  def toughness
    0
  end

  def tags
    tags = []
    tags << "creature" if is_creature?
    tags << "land" if is_land?
    tags << "spell" if is_spell?
    tags << "instant" if is_instant?
    tags << "enchantment" if is_enchantment?
    tags.uniq
  end

  def playing_goes_onto_stack?(action_key)
    send("playing_#{action_key}_goes_onto_stack?")
  end

  def mana_cost
    Mana.new
  end

  def cost_string
    mana_cost.to_s
  end

  def actions
    methods.grep(/^(actions_for)_/).map{ |m| m["actions_for_".length..-1] }
  end

  def conditions_for(action_key)
    send("conditions_for_#{action_key}")
  end

  def can_attack?
    is_creature?
  end

  def can_defend?
    is_creature?
  end

  def can_do_action?(duel, action)
    conditions_for(action.key).send(:evaluate, duel, action)
  end

  def action_cost(action_key)
    send("#{action_key}_cost")
  end

  def actions_for(action_key)
    send("actions_for_#{action_key}")
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
