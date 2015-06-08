class GameEngine
  def initialize(duel)
    @duel = duel
  end

  def duel
    @duel
  end

  # list all available actions
  def available_actions
    actions = {
      play: []
    }
    if @duel.phase == 2
      actions[:play] += playable_cards
    end
    actions
  end

  def playable_cards
    @duel.active_player.hand
  end

  def play(hand)
    # remove from hand
    hand.destroy!

    # add to the battlefield
    Battlefield.create!( player: hand.player, entity: hand.entity )

    # action
    Action.play_card_action(@duel, hand.player, hand.entity)
  end

  def draw_card(player)
    # remove from deck
    card = player.deck.first!
    card.destroy

    # add it to the hand
    Hand.create!( player: player, entity: card.entity )

    # action
    Action.draw_card_action(@duel, player)
  end

  def card_action(card, action_index)
    fail "No card specified" unless card

    card.entity.find_card.do_action self, card, action_index

    # action
    Action.tap_card_action(@duel, card.player, card.entity)

    # clear any other references
    @duel.reload
  end

  # TODO maybe put into a phase manager service?

  def draw_phase
    # the current player draws a card
    draw_card(@duel.active_player) if @duel.current_player == @duel.priority_player
  end

  def play_phase
    # empty
  end

  def attack_phase
    # empty
  end

  def cleanup_phase
    # empty
  end


end
