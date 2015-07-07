rmagic [![Build Status](https://travis-ci.org/soundasleep/rmagic.svg?branch=master)](https://travis-ci.org/soundasleep/rmagic) [![Code Climate](https://codeclimate.com/github/soundasleep/rmagic/badges/gpa.svg)](https://codeclimate.com/github/soundasleep/rmagic) [![Test Coverage](https://codeclimate.com/github/soundasleep/rmagic/badges/coverage.svg)](https://codeclimate.com/github/soundasleep/rmagic/coverage)
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
* Spells and creatures interacting on the stack
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

* Move phase actions, game engine actions into testable services
* Support more game phases correctly
* Summoning sickness for activated abilities
* Render the cards on the stack in the web interface
* Sorceries
* Deck shuffling and drawing
* Random first player
* Order cards in graveyard
* Tests for controllers
* Mulligans
* Look into Cucumber or Capybara for integration testing

## Release 1 goals

* Supports [Fate vs Fury](http://sales.starcitygames.com/carddisplay.php?product=695013) deck
* Flying, reach
* Scry
* Distribute damage
* Search through library
* Discard a card
* Devotion
* Event triggers

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
