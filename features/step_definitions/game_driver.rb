class GameDriver
  include GameHelper

  def duel
    @duel ||= create_game
  end

  def player1
    @duel.player1
  end

  def player2
    @duel.player2
  end
end

def game_driver
  @game_driver ||= GameDriver.new
end

def duel
  @duel ||= @game_driver.duel
end

