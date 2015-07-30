# TODO could this be a Serializer instead?
class PlayerPresenter < JSONPresenter
  # TODO should be able to remove this
  def initialize(player)
    super(player)     # TODO could just be `super` (passes args)
  end

  def player
    object
  end

  def player_json
    to_json
  end

  def deck_json(context = nil)
    {
      deck: player.deck.map { |c| format_card c, context }
    }
  end

  def battlefield_json(context = nil)
    {
      battlefield: player.battlefield.map { |c| format_card c, context }
    }
  end

  def hand_json(context = nil)
    {
      hand: player.hand.map { |c| format_card c, context }
    }
  end

  def graveyard_json(context = nil)
    {
      graveyard: player.graveyard.map { |c| format_card c, context }
    }
  end

  def actions_json(context = nil)
    {
      play: action_finder.playable_cards(player).map { |a| format_action a },
      ability: action_finder.ability_cards(player).map { |a| format_action a },
      defend: action_finder.defendable_cards(player).map { |a| format_defend_action a },
      attack: action_finder.available_attackers(player).map { |a| format_card a },
      game: action_finder.game_actions(player).map { |a| format_game_action a }
    }
  end

  def self.safe_json_attributes
    [ :id, :name, :mana, :life ]
  end

  def extra_json_attributes(context = nil)
    {
      mana: player.mana_pool.to_hash,
      mana_string: player.mana
    }
  end

  private

    def action_finder
      ActionFinder.new(player.duel)
    end

    def format_card(card, context = nil)
      # TODO rename to_json to as_json (same semantics)
      ZoneCardPresenter.new(card).to_json(context)
    end

    def format_action(action)
      ActionPresenter.new(action).to_json
    end

    def format_defend_action(action)
      DefendActionPresenter.new(action).to_json
    end

    def format_game_action(action)
      GameActionPresenter.new(action).to_json
    end

end
