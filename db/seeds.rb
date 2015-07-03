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

# from http://sales.starcitygames.com/carddisplay.php?product=695013
deck = system.premade_decks.create! name: "Fury"

# create_card deck, Library::ArborColossus
# create_card deck, Library::CourserOfKruphix
# create_card deck, Library::ElvishMystic, 4
# create_card deck, Library::GeneratorServant, 2
# create_card deck, Library::GenesisHydra
# create_card deck, Library::HydraBroodmother
# create_card deck, Library::IllTemperedCyclops, 2
# create_card deck, Library::KarametrasAcolyte, 3
# create_card deck, Library::NemesisOfMortals, 2
create_card deck, Library::NessianCourser
# create_card deck, Library::NessianGameWarden, 3
# create_card deck, Library::NyleasDisciple, 3
# create_card deck, Library::ReclamationSage, 2
# create_card deck, Library::VoyagingSatyr, 2

# create_card deck, Library::Boulderfall
# create_card deck, Library::FatedIntervention
# create_card deck, Library::FontOfFertility
# create_card deck, Library::LightningStrike, 2
# create_card deck, Library::Plummet, 2

create_card deck, Library::Forest, 15
create_card deck, Library::Mountain, 9
# create_card deck, Library::NykthosShrineToNyx

deck.cards.create! metaverse_id: Library::Forest.metaverse_id

# from http://sales.starcitygames.com/carddisplay.php?product=695013
deck = system.premade_decks.create! name: "Fate"

# create_card deck, Library::FrostLynx, 2
# create_card deck, Library::HorizonChimera, 3
# create_card deck, Library::HypnoticSiden
# create_card deck, Library::KiorasFollower, 3
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
# create_card deck, Library::PinToTheEarth, 2
# create_card deck, Library::VoyagesEnd

create_card deck, Library::Forest, 7
create_card deck, Library::Island, 17
# create_card deck, Library::TempleOfMystery
