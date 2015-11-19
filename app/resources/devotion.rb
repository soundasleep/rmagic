class Devotion
  attr_reader :player
  attr_accessor :green, :blue, :red, :white, :black, :colourless

  def initialize(player)
    @player = player
  end

  def call
    [:green, :blue, :red, :white, :black, :colourless].each do |colour|
      devotion = player.battlefield.map(&:card).map(&:card_type).map(&:mana_cost)
        .map do |mana_cost|
          mana_cost.send(colour)
        end.sum
      send("#{colour}=", devotion)
    end

    self
  end
end
