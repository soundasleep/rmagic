Feature: Karametra's Acolyte
  Scenario: We can use the ability of Karametra's Acolyte
    Given we add one "Karametra's Acolyte" to our battlefield
    And it is the playing phase
    Then we can ability our first "Karametra's Acolyte"

    When we ability our first "Karametra's Acolyte"
    Then we can not ability our first "Karametra's Acolyte"

  Scenario: We use devotion to get mana with Karametra's Acolyte
    Given we add one "Karametra's Acolyte" to our battlefield
    And it is the playing phase
    Then we have 0 mana
    And our first "Karametra's Acolyte" is not tapped

    When we ability our first "Karametra's Acolyte"
    Then our first "Karametra's Acolyte" is tapped
    And we have 1 green mana

  Scenario: We have two Karametra's Acolytes
    Given we add two "Karametra's Acolyte" to our battlefield
    And it is the playing phase

    When we ability our first "Karametra's Acolyte"
    Then we have 2 green mana

    When we ability our second "Karametra's Acolyte"
    Then we have 4 green mana

