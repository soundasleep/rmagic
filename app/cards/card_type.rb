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

  def is_instant?
    false
  end

  def playing_goes_onto_stack?(key)
    send("playing_#{key}_goes_onto_stack?")
  end

  def mana_cost
    {}
  end

  def cost_string
    mana_cost_string(mana_cost)
  end

  def actions
    do_actions + resolve_actions
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

    if playing_goes_onto_stack?(action.key)
      # we don't want to call do_() directly
      game_engine.move_into_stack action.source.player, action.source, action.key, action.target

      # and priority returns to the current player
      game_engine.duel.reset_priority!
    else
      # it doesn't affect the stack at all
      send("do_#{action.key}", game_engine, action.source, action.target)
    end
  end

  def resolve_action(game_engine, stack)
    fail "Cannot resolve 'stack'" if stack.key == "action"
    send("resolve_#{stack.key}", game_engine, stack)
  end

  # TODO remove and replace with .id
  def metaverse_id
    self.class.id
  end

  def self.id
    name.split(/[^0-9]/).last.to_i
  end

  def id
    metaverse_id
  end

  private
    def do_actions
      methods.grep(/^(do)_/).map{ |m| m["do_".length..-1] } - ["action"]
    end

    def resolve_actions
      methods.grep(/^(resolve)_/).map{ |m| m["resolve_".length..-1] } - ["action"]
    end

end
