When(/^we declare "([^"]*)" as an attacker$/) do |card_name|
  attackers = game_driver.available_attackers.select do |attacker|
    attacker.card.card_type.name == card_name
  end

  expect(attackers).to_not be_empty
  expect(attackers.length).to eq(1)

  attacker = attackers.first
  game_driver.declare_attackers [attacker]
end

When(/^combat resolves$/) do
  game_driver.pass_until_next_phase
end
