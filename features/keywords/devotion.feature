Feature: Devotion mechanic
  Scenario: Devotion counts green mana circles
    Given we add two "Karametra's Acolyte" to our battlefield
    Then our devotion to green is 2
    And our devotion to red is 0

  Scenario: Devotion does not count non-green cards
    Given we add two "Skyraker Giant" to our battlefield
    Then our devotion to green is 0
    And our devotion to red is 4
