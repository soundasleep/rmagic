def string_to_i(s)
  case s
  when "one"
    1
  when "two"
    2
  else
    raise "I don't know how many are in #{s}"
  end
end

Given(/^we add ([^ ]+) "([^"]*)" to our battlefield$/) do |count, card|
  card = Library.new.find_card(card)

  string_to_i(count).times do
    game_driver.create_card player1.battlefield, card
  end
end

Given(/^our opponent adds ([^ ]+) "([^"]*)" to their battlefield$/) do |count, card|
  card = Library.new.find_card(card)

  string_to_i(count).times do
    game_driver.create_card player2.battlefield, card
  end
end

When(/^our opponent declares "([^"]*)" as a blocker for our "([^"]*)"$/) do |card1, card2|
  defenders = game_driver.action_finder.defendable_cards(player2)
  expect(defenders).to_not be_empty, "There were no possible defenders"

  defenders = defenders.select do |card|
    card.source.card.name == card1 && card.target.card.name
  end
  expect(defenders).to_not be_empty, "There were no possible defenders from #{card1} to #{card2}"
  expect(defenders.length).to eq(1)

  defender = defenders.first
  defender.declare duel
end

Then(/^our battlefield has no creatures$/) do
  expect(player1.battlefield_creatures).to be_empty
end

Then(/^our opponent's battlefield has no creatures$/) do
  expect(player2.battlefield_creatures).to be_empty
end
