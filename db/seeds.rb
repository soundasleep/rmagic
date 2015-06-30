# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

system = User.create! name: "System"

deck = system.premade_decks.create! name: "Fury"

deck.cards.create! metaverse_id: Library::Forest.id

deck = system.premade_decks.create! name: "Fate"

deck.cards.create! metaverse_id: Library::Island.id
