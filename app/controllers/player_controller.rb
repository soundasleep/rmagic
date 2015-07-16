class PlayerController < ApplicationController
  include ActionableController

  before_filter :authenticate

  def show
    @duel = duel
    @player = player

    if !@duel.players.include?(@player)
      fail "That player #{player} is not in the duel #{duel}"
    end

    respond_to do |format|
      format.html
      format.json { render :json => @player.safe_json }
    end
  end

  helper_method :playable_cards, :ability_cards, :defendable_cards,
      :available_attackers, :game_actions
  helper_method :get_target_type

  def playable_cards
    action_finder.playable_cards player
  end

  def ability_cards
    action_finder.ability_cards player
  end

  def defendable_cards
    action_finder.defendable_cards player
  end

  def available_attackers
    action_finder.available_attackers player
  end

  def game_actions
    action_finder.game_actions player
  end

  def all_actions_json
    {
      play: action_finder.playable_cards(player).map(&:safe_json),
      ability: action_finder.ability_cards(player).map(&:safe_json),
      defend: action_finder.defendable_cards(player).map(&:safe_json),
      attack: action_finder.available_attackers(player).map(&:safe_json),
      game: action_finder.game_actions(player).map(&:safe_json)
    }
  end

  def actions
    respond_to do |format|
      format.json { render :json => all_actions_json }
    end
  end

  def declare_attackers
    if params[:attacker]
      attackers = Battlefield.find(params[:attacker])
      DeclareAttackers.new(duel: duel, zone_cards: attackers).call
    end
    duel.save!    # TODO remove

    # and then pass
    action = GameAction.new(
      player: player,
      key: "pass"
    )
    action.do(duel)

    redirect_to duel_player_path duel, player
  end

  def game_action
    action = GameAction.new(
      player: player,
      key: params[:key]
    )
    action.do(duel)
    redirect_to duel_player_path duel, player
  end

  private
    def duel
      Duel.find(params[:duel_id])
    end

    def player
      Player.find(params[:id])
    end

    def action_finder
      @action_finder ||= ActionFinder.new(duel)
    end

end
