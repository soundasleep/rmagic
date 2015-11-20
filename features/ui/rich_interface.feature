Feature: A gorgeous web interface
  # TODO move into sessions.feature
  Scenario: Logging into the web interface
    When I log in
    Then I should see "Logged in as"
    And I should see "Log out"

  @broken-on-travis
  @javascript
  Scenario: Creating a new duel with premade decks loads the rich web interface
    When I log in
    And I start a new game versus the AI using the "Fate v Fury" premade deck

    Then I should see "Action log"
    And I should see "Battlefield"
    And I should see "Hand"
    And I should see "Stack"
    And I should see "20 life"
    And I should see "AI"

  @broken-on-travis
  @javascript
  Scenario: The web interface uses websockets and pings to make sure the connection is working
    When I log in
    And I start a new game versus the AI using the "Fate v Fury" premade deck
    And I wait until I no longer see "connecting to websocket..."
    Then I should not see "connecting to websocket..."

  @broken-on-travis
  @javascript
  Scenario: I can start a new game with the rich web interface
    When I log in
    And I start a new game versus the AI using the "Fate v Fury" premade deck

    Then I should see a button "Pass"
    And I should see a button "Concede"
    And I should see a button "Mulligan"

    When I click the button "Pass"
    And I wait for the AI to pass

    Then I should see "Hand (7 cards)"
    And I should see "Battlefield (0 cards)"

    And I should see a button "Pass"
    And I should see a button "Concede"
    And I should not see a button "Mulligan"
