system = User.where(name: "System").first!

# from http://sales.starcitygames.com/carddisplay.php?product=695013
deck = system.premade_decks.create! name: "Fate"

# create_card deck, Library::FrostLynx, 2
# create_card deck, Library::HorizonChimera, 3
# create_card deck, Library::HypnoticSiden
create_card deck, Library::KiorasFollower, 3
# create_card deck, Library::LeafcrownDryad, 2
# create_card deck, Library::NimbusNaiad, 2
# create_card deck, Library::Omenspeaker, 2
# create_card deck, Library::ThassasEmissary, 2
# create_card deck, Library::PrognosticSphinx
# create_card deck, Library::ProphetOfKruphix
# create_card deck, Library::Vaporkin, 3

# create_card deck, Library::Aetherspouts
# create_card deck, Library::Divination, 2
# create_card deck, Library::CurseOfTheSwine
# create_card deck, Library::Griptide, 2
# create_card deck, Library::JacesIngenuity, 2
create_card deck, Library::Negate, 2
create_card deck, Library::PinToTheEarth, 2
# create_card deck, Library::VoyagesEnd

create_card deck, Library::Forest, 7
create_card deck, Library::Island, 17
# create_card deck, Library::TempleOfMystery
