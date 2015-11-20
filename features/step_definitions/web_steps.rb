require "capybara/cucumber"

When(/^I log in$/) do
  visit "/"
  steps %Q{
    And I should see "You need to login first"
    And I should not see "Log out"
  }
  click_link "Log in"
  click_button "Emulate OAuth2 sign in"
  steps %Q{
    And I should see "Signed in"
    And I should see "Log out"
  }
end

def page_text
  find(:xpath, "//body").text
end

Then(/^I should see "([^"]*)"$/) do |text|
  expect(page_text).to include(text)
end

Then(/^I should not see "([^"]*)"$/) do |text|
  expect(page_text).to_not include(text)
end

Then(/^I should see a button "([^"]*)"$/) do |text|
  find_button(text)
end

Then(/^I should not see a button "([^"]*)"$/) do |text|
  expect(all(:xpath, "//input", text: text)).to be_empty
end

When(/^I click the button "([^"]*)"$/) do |text|
  click_button text
end

def page_contains(text)
  t = page_text
  !t || t.include?(text)
end

When(/^I wait until I no longer see "([^"]*)"$/) do |text|
  Timeout.timeout(Capybara.default_max_wait_time) do
    loop until !page_contains(text)
  end
end

When(/^I wait until I see a button "([^"]*)"$/) do |text|
  Timeout.timeout(Capybara.default_max_wait_time) do
    loop until find_button(text) != nil
  end
end

When(/^I start a new game versus the AI using the "([^"]*)" premade deck$/) do |deck_name|
  click_button deck_name
  steps %Q{
    And I wait until I no longer see "loading..."
  }
end

When(/^I wait for the AI to pass$/) do
  steps %Q{
    And I wait until I no longer see "loading..."
    And I wait until I see a button "Pass"
  }
end
