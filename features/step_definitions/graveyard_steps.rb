Then(/^our graveyard is empty$/) do
  expect(player1.graveyard).to be_empty
end

Then(/^our opponent's graveyard is empty$/) do
  expect(player2.graveyard).to be_empty
end

Then(/^our graveyard has one "([^"]*)"$/) do |name|
  cards = player1.graveyard.select { |graveyard| graveyard.card.name == name }
  expect(cards).to_not be_empty
  expect(cards.length).to eq(1)
end

Then(/^our opponent's graveyard has one "([^"]*)"$/) do |name|
  cards = player2.graveyard.select { |graveyard| graveyard.card.name == name }
  expect(cards).to_not be_empty
  expect(cards.length).to eq(1)
end
