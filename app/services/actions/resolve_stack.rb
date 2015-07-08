class ResolveStack
  attr_reader :duel

  def initialize(duel:)
    @duel = duel
  end

  def call
    i = 0

    # stack is in bottom-top order
    while !stack.empty? do
      # the actions may modify the stack itself, so we loop instead of each
      target = stack.reverse.first

      ResolveAction.new(duel: duel, action: target).call

      i += 1
      fail("Resolving the stack never completed after #{i} iterations") if i > 100
    end

    stack.destroy_all

    true
  end

  private
    def stack
      duel.stack
    end

end
