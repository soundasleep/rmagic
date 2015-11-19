Given(/^we have a game$/) do
  expect(duel).to_not be_nil
end

Given(/^it is the attack phase$/) do
  step "And it is the attacking phase"
end

Given(/^it is the ([^ ]+ing) phase$/) do |phase|
  duel.send("#{phase}_phase!")
end

Then(/^we have (\d+) life$/) do |number|
  expect(player1.life).to eq(number.to_i)
end

Then(/^our opponent has (\d+) life$/) do |number|
  expect(player2.life).to eq(number.to_i)
end

Then(/^we have (\d+) mana$/) do |number|
  expect(player1.mana_pool.converted_cost).to eq(number.to_i)
end

Then(/^we have (\d+) green mana$/) do |number|
  expect(player1.mana_pool).to eq(Mana.new({
    green: number.to_i
  }))
end
