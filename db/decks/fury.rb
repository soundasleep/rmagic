system = User.where(name: "System").first!

# from http://sales.starcitygames.com/carddisplay.php?product=695013
deck = system.premade_decks.create! name: "Fury"

# create_card deck, Library::ArborColossus
# create_card deck, Library::CourserOfKruphix
create_card deck, Library::ElvishMystic, 4
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
create_card deck, Library::LightningStrike, 2
# create_card deck, Library::Plummet, 2

create_card deck, Library::Forest, 15
create_card deck, Library::Mountain, 9
# create_card deck, Library::NykthosShrineToNyx

