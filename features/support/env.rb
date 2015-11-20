require File.expand_path('../../../config/environment', __FILE__)
require 'rspec/rails'
require File.expand_path('../../../spec/game_helpers', __FILE__)

require 'capybara/rails'
Capybara.default_max_wait_time = 20

Capybara.server do |app, port|
  require 'rack/handler/thin'
  ENV["WEBSOCKET_LOCATION"] = "127.0.0.1:#{port}/websocket"

  Rack::Handler::Thin.run(app, :Port => port)
end

require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

# TODO can this be deleted?
require_relative "game_driver"
