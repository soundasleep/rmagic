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
    send("can_#{action_key}?")
  end

  def can_do_action?(game_engine, action)
    condition = conditions_for(action.key)

    fail "Condition #{condition} for #{action.key} on #{action.source} does not have evaluate method" unless condition.respond_to? :evaluate

    condition.send(:evaluate, game_engine, action)
  end

  def action_cost(game_engine, action)
    fail "Cannot get cost of 'action'" if action.key == "action"
    send("#{action.key}_cost", game_engine, action)
  end

  def actions_for(action_key)
    send("do_#{action_key}")
  end

  def do_action(game_engine, action)
    fail "Cannot do 'action'" if action.key == "action"

    if playing_goes_onto_stack?(action.key)
      # TODO this could be implemented as an Action itself!
      # e.g. 'put onto stack', 'reset priority'
      # we don't want to call do_() directly
      game_engine.move_into_stack action.source.player, action.source, action.key, action.target

      # and priority returns to the current player
      game_engine.duel.reset_priority!
    else
      # it doesn't affect the stack at all
      executor = actions_for(action.key)

      fail "Action #{executor} for #{action.key} on #{action.source} does not have execute method" unless executor.respond_to? :execute

      executor.send(:execute, game_engine, action)
    end
  end

  def resolve_action(game_engine, stack)
    fail "Cannot resolve 'stack'" if stack.key == "action"
    executor = actions_for(stack.key)

    fail "Action #{executor} for #{stack.key} on #{stack.card.card_type} does not have execute method" unless executor.respond_to? :execute

    executor.send(:execute, game_engine, stack)
  end

  def metaverse_id
    self.class.metaverse_id
  end

  def self.metaverse_id
    name.split(/[^0-9]/).last.to_i
  end

end
