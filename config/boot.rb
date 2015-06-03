ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup' # Set up gems listed in the Gemfile.

# Load all card definitions
Dir[File.dirname(__FILE__) + '/../app/cards/**/*.rb'].each {|file| require file }
