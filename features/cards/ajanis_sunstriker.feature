Feature: Ajani's Sunstriker
  Scenario: We attack with an Ajani's Sunstriker
    Given we have one "Ajani's Sunstriker" on the battlefield
    And it is the attack phase
    And we have 20 life
    And our opponent has 20 life

    When we declare "Ajani's Sunstriker" as an attacker
    And we pass
    And our opponent does not declare any blockers
    And combat resolves

    Then our opponent has 18 life
    And we have 22 life

  Scenario: When two Ajani's Sunstrikers attack and block each other
    Given we have one "Ajani's Sunstriker" on the battlefield
    And our opponent has one "Ajani's Sunstriker" on the battlefield

    And it is the attack phase
    And we have 20 life
    And our opponent has 20 life
    And our graveyard is empty
    And our opponent's graveyard is empty

    When we declare "Ajani's Sunstriker" as an attacker
    And we pass
    And our opponent declares "Ajani's Sunstriker" as a blocker for our "Ajani's Sunstriker"
    And combat resolves

    Then our opponent has 22 life
    And we have 22 life

    And our battlefield has no creatures
    And our opponent's battlefield has no creatures
    And our graveyard has one "Ajani's Sunstriker"
    And our opponent's graveyard has one "Ajani's Sunstriker"
