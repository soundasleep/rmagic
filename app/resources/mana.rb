class Mana
  attr_accessor :green, :blue, :red, :white, :black, :colourless

  def initialize(green: 0, blue: 0, red: 0, white: 0, black: 0, colourless: 0)
    self.green = green
    self.blue = blue
    self.red = red
    self.white = white
    self.black = black
    self.colourless = colourless
  end

  def to_s
    result = "{" +
      ( if colourless > 0 then colourless.to_s else "" end ) +
      ( "g" * green ) +
      ( "u" * blue ) +
      ( "b" * black ) +
      ( "r" * red ) +
      ( "w" * white ) +
      "}"

    result = "{0}" if result == "{}"
    result
  end

  def to_hash
    result = {}
    self.class.colours.each do |c|
      result[c] = self.send(c)
    end
    result
  end

  def add(cost)
    result = {}
    self.class.colours.each do |c|
      result[c] = self.send(c) + cost.send(c)
    end
    Mana.new(result)
  end

  def use(mana_cost)
    pool = to_hash
    cost = mana_cost.to_hash

    # first use core mana
    [ :green, :blue, :red, :white, :black ].each do |c|
      (1..cost[c]).each do
        return false if pool[c] <= 0
        pool[c] -= 1
      end
    end

    (1..cost[:colourless]).each do
      if pool[:colourless] > 0
        pool[:colourless] -= 1
        next
      end
      # TODO request priority
      if pool[:green] > 0
        pool[:green] -= 1
        next
      end
      if pool[:blue] > 0
        pool[:blue] -= 1
        next
      end
      if pool[:red] > 0
        pool[:red] -= 1
        next
      end
      if pool[:white] > 0
        pool[:white] -= 1
        next
      end
      if pool[:black] > 0
        pool[:black] -= 1
        next
      end

      return false
    end

    Mana.new(pool)
  end

  def self.colours
    [ :green, :blue, :red, :white, :black, :colourless ]
  end

  def ==(target)
    target.is_a?(Mana) && to_hash == target.to_hash
  end

end
