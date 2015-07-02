# TODO remove this out of /helpers - /helpers is for rails views only?
# maybe /resources
module ManaHelper
  def zero_mana
    {
      green: 0,
      blue: 0,
      red: 0,
      white: 0,
      black: 0,
      colourless: 0
    }
  end

  # should this be a helper?
  def mana_cost_string(mana)
    cost = zero_mana.merge(mana)

    result = "{" +
      ( if cost[:colourless] > 0 then cost[:colourless].to_s else "" end ) +
      ( "g" * cost[:green] ) +
      ( "u" * cost[:blue] ) +
      ( "b" * cost[:black] ) +
      ( "r" * cost[:red] ) +
      ( "w" * cost[:white] ) +
      "}"

    result = "{0}" if result == "{}"

    result
  end

  def check_supported_colours!(pool)
    pool.keys.each do |key|
      fail "Unsupported colour key '#{key}' in pool #{pool}" unless [:green, :blue, :red, :white, :black, :colourless].include?(key)
    end
  end

  def add_mana_to_pool(cost, pool)
    check_supported_colours!(cost)
    check_supported_colours!(pool)

    result = {}
    [:green, :blue, :red, :white, :black, :colourless].map do |c|
      result[c] = pool[c] + cost[c]
    end
    result
  end

  def use_mana_from_pool(cost, pool)
    check_supported_colours!(cost)
    check_supported_colours!(pool)

    [:green, :blue, :red, :white, :black].each do |c|
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

    return pool
  end

end
