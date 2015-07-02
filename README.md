rmagic
======

*rmagic* is a Ruby on Rails implementation of Magic the Gathering.

The engine barely supports anything at the moment, but it's a start.

## Features

* [Lots of tests](spec/games/)
* (Hopefully) amazingly clean code
* Declare attackers and defenders
* Tapping cards for mana
* Instants from cards, abilities from creatures, targeting both cards and players
* Temporary effects modifying power/toughness on creatures
* Activated abilities considering summoning sickness
* Spells (not creatures) interact on the stack
* Counter spells

## ActiveRecord concepts

We try to use as few model objects as possible.

* `Card` - cards
* `Effect` - temporary and permanent effects on cards
* `Player` - life, unspent mana
* `Duel` - current player, phase
* `Battlefield`, `Deck`, `Graveyard`, `Hand`, `Exile` - zones where `Card`s are
* `ActionLog` - something that happened (optionally with many `ActionLogTarget`s) - try and do everything with ActionLogs (e.g. `draw`, `tap`, `untap`, `attack`, `defend`)
* `DeclaredAttacker`, `DeclaredDefender` - temporary wrappers around declared attackers, defenders

## TODO

* Represents actions as classes/services rather than methods?
* Support more game phases correctly
* Summoning sickness for activated abilities
* Creatures interact on the stack and can be countered
* Render the cards on the stack in the web interface
* Sorceries
* Deck shuffling and drawing
* Random first player
* Order cards in graveyard
* Continuous testing
* Tests for controllers
* Mulligans
* Look into Cucumber or Capybara for integration testing

## Release 1 goals

* Supports Fate vs Fury deck

## Release 2 goals

* Multiplayer interface with OAuth2 login

## Later goals

* Specify resolved attack priority order
* An AI that makes sense
* Support exile zone
* Javascript REST-driven to enable a rich user experience
* Chat
* Card graphics

## Probably never

* More than two player games
* Different game modes
* Data-driven cards, rather than [in Ruby](app/cards/)
* Comparison of supported features to the [comprehensive rules](http://magiccards.info/rules.html)

## Tests

```
rake spec
```
