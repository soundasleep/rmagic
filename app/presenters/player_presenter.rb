class PlayerPresenter
  attr_reader :player

  def initialize(player)
    @player = player
  end

  def deck_json
    {
      deck: player.deck.map { |c| format_card c }
    }
  end

  def battlefield_json
    {
      battlefield: player.battlefield.map { |c| format_card c }
    }
  end

  def hand_json
    {
      hand: player.hand.map { |c| format_card c }
    }
  end

  def graveyard_json
    {
      graveyard: player.graveyard.map { |c| format_card c }
    }
  end

  def actions_json
    {
      play: action_finder.playable_cards(player).map { |a| format_action a },
      ability: action_finder.ability_cards(player).map { |a| format_action a },
      defend: action_finder.defendable_cards(player).map { |a| format_action a },
      attack: action_finder.available_attackers(player).map { |a| format_action a },
      game: action_finder.game_actions(player).map { |a| format_game_action a }
    }
  end

  private

    def action_finder
      ActionFinder.new(player.duel)
    end

    def format_card(card)
      ZoneCardPresenter.new(card).to_safe_json
    end

    def format_action(action)
      ActionPresenter.new(action).to_safe_json
    end

    def format_game_action(action)
      GameActionPresenter.new(action).to_safe_json
    end

end
