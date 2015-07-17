class AbstractAction
  attr_reader :source, :key, :target, :action_type

  def initialize(action_type:, source:, key:, target: nil)
    @action_type = action_type
    @source = source
    @key = key
    @target = target
  end

  def description
    "#{action_description} #{key} of #{source.to_text}#{target_text}"
  end

  def battlefield_targets
    [WrappedTarget.new(target)]
  end

  def graveyard_targets
    [WrappedTarget.new(target)]
  end

  def player_targets
    [WrappedTarget.new(target)]
  end

  class WrappedTarget
    attr_reader :target

    def initialize(target)
      @target = target
    end
  end

  def conditions
    ConditionsForAction.new self
  end

  def actions
    ActionsForAction.new self
  end

  def player
    source.player
  end

  def card
    source.card
  end

  def can_do?(duel)
    source.card.card_type.can_do_action?(duel, self) &&
      source.player.has_mana?(source.card.card_type.action_cost(key))
  end

  def do(duel)
    DoAction.new(duel: duel, action: self).call
  end

  def safe_json
    {
      action_type: action_type,
      source_id: source.id,
      key: key,
      target_type: target_type,
      target_id: target ? target.id : nil,
      description: description
    }
  end

  def target_type
    return "none" if target == nil
    case target.class.name
      when "Player"
        "player"
      when "Battlefield"
        "battlefield"
      when "DeclaredAttacker"
        "declared_attacker"
      else
        fail "Unknown target type '#{target.class.name}'"
    end
  end

  private

    def target_text
      if target
        " on #{target.to_text}"
      else
        ""
      end
    end

    def to_s
      {action_type: action_type, source: source, key: key, target: target}.to_s
    end

end
