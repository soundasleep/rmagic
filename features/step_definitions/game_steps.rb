Given(/^we have a game$/) do
  expect(duel).to_not be_nil
end

Given(/^it is the attack phase$/) do
  duel.attacking_phase!
end

Then(/^we have (\d+) life$/) do |number|
  expect(player1.life).to eq(number.to_i)
end

Then(/^our opponent has (\d+) life$/) do |number|
  expect(player2.life).to eq(number.to_i)
end
