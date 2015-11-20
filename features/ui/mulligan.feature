Feature: The web interface helps us through the mulligan concept
  @broken-on-travis
  @javascript
  Scenario: We can mulligan using yes/no buttons
    When I log in
    And I start a new game versus the AI using the "Fate v Fury" premade deck

    Then I should see "Do you want to keep this hand?"
    And I should see "Hand (7 cards)"

    And I should see a button "Yes"
    And I should see a button "No"

    When I click the button "No"
    And I wait for the AI to pass

    Then I should see "Do you want to keep this hand?"
    And I should see "Hand (7 cards)"

    And I should see a button "Yes"
    And I should see a button "No"

    When I click the button "Yes"
    And I wait for the AI to pass

    Then I should not see "Do you want to keep this hand?"
    And I should see "Hand (6 cards)"
