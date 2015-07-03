# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

def create_card(deck, card, count = 1)
  count.times do
    deck.cards.create! metaverse_id: card.metaverse_id
  end
end

system = User.create! name: "System"

require_relative 'decks/fate'
require_relative 'decks/fury'
