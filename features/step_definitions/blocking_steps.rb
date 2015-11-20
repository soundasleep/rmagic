When(/^our opponent does not declare any blockers$/) do
  expect(duel.priority_player).to eq(player2)
  steps %Q{
    And we pass
  }
end
