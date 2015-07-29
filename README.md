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
* Enchantments attached to cards
* Counter spells
* Deck shuffling and drawing
* Mulligans
* Random first player
* Basic multiplayer interface with OAuth2 login
* Javascript REST-driven to enable a rich user experience
* Card graphics
* Flying, reach
* Games can end, be won, be lost, be drawn

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

* Support more game phases correctly
* Summoning sickness for activated abilities
* Sorceries
* Tests for controllers
* Look into Cucumber or Capybara for integration testing
* Deployed onto a VPS somewhere
* Display counters on cards on web interface
* Token creatures
* Look at [bullet](https://github.com/flyerhzm/bullet) or [rack-mini-profiler](https://github.com/MiniProfiler/rack-mini-profiler) to improve game performance

## Release 0 goals

* Prevent players from being jerks
* Render full card on /cards web interface

## Release 1 goals

* Supports [Fate vs Fury](http://sales.starcitygames.com/carddisplay.php?product=695013) deck
* Scry
* Distribute damage
* Search through library
* Discard a card
* Maximum hand size
* Devotion
* Event triggers

## Later goals

* Specify resolved attack priority order
* An AI that makes sense
* Support exile zone
* User chat

## Probably never

* More than two player games
* Different game modes
* Data-driven cards, rather than [in Ruby](app/cards/)
* Comparison of supported features to the [comprehensive rules](http://magiccards.info/rules.html)

## Development

You'll want three terminals running each of:

* `rails server` - to catch changes in the Rails app
* `grunt serve` - to catch changes in the React app
* `guard` - to enable [LiveReload](https://mattbrictson.com/lightning-fast-sass-reloading-in-rails)

## Tests

```
rake spec
```
