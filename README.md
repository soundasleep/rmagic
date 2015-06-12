rmagic
======

*rmagic* is a Ruby on Rails implementation of Magic the Gathering.

The engine barely supports anything at the moment, but it's a start.

## Features

* [Lots of tests](spec/games/)
* (Hopefully) amazingly clean code
* Declare attackers and defenders
* Tapping cards for mana

## ActiveRecord concepts

We try to use as few model objects as possible.

* `Entity` - cards, tokens
* `Player` - life, unspent mana
* `Duel` - current player, phase
* `Battlefield`, `Deck`, `Graveyard`, `Hand`, `Exile` - zones where cards are
* `Action` - something that happened (optionally with many `ActionTarget`s) - try and do everything with Actions (e.g. `draw`, `tap`, `untap`, `attack`, `defend`)
* `DeclaredAttacker`, `DeclaredDefender` - temporary wrappers around declared attackers, defenders

## TODO

* Rewrite specs with contexts rather than `it`s
* Represents actions as classes/services rather than methods?
* Support more game phases correctly
* Summoning sickness
* Instants
* Activated abilities
* Sorceries
* Effects on entities (cards)
* Represent player as an entity
* Deck shuffling and drawing
* Random first player
* Order cards in graveyard
* Continuous testing
* Tests for controllers
* Mulligans

## Release 1 goals

* Supports Fate vs Fury deck

## Release 2 goals

* Multiplayer interface with OAuth2 login

## Later goals

* Specify resolved attack priority order
* An AI that makes sense
* Support exile
* Javascript REST-driven to enable a rich user experience
* Chat
* Card graphics

## Probably never

* More than two player games
* Different game modes
* Data-driven cards, rather than [in Ruby](app/cards/)

## Tests

```
rake spec
```
