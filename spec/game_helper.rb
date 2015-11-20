require "rails_helper"
require "game_helpers"

RSpec.configure do |c|
  # can this be moved into individual specs instead?
  # that way not every single game test has to load all of GameHelper every time?
  c.include GameHelper
end

