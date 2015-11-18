system = User.where(name: "System").first!

deck = system.premade_decks.create! name: "Mono White"

create_card deck, Library::AjanisSunstriker, 15

create_card deck, Library::Plains, 15
