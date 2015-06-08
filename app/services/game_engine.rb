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
    # all cards where we have enough mana
    @duel.active_player.hand.select do |hand|
      @duel.active_player.has_mana? hand.entity.find_card!.mana_cost
    end
  end

  def play(hand)
    # remove from hand
    hand.destroy!

    # do 'play' action
    card_action hand, "play"
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

  def card_action(card, key)
    fail "No card specified" unless card

    card.entity.find_card!.do_action self, card, key

    # action
    Action.card_action(@duel, card.player, card.entity, key)

    # clear any other references
    @duel.reload
  end

  # TODO this doesn't count e.g. green mana is also colourless mana
  def use_mana!(player, hand)
    card = hand.entity.find_card!

    player.use_mana card.mana_cost
    player.save!
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
