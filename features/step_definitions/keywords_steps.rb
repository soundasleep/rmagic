Then(/^our devotion to ([^ ]+) is (\d+)$/) do |colour, number|
  expect(player1.devotion.send(colour)).to eq(number.to_i)
end
