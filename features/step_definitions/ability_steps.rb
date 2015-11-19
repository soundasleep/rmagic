def named_card(player, card)
  player.battlefield.select do |battlefield|
    battlefield.card.name == card
  end
end

Then(/^we have a ([^ ]+) "([^"]*)" in our battlefield$/) do |index, card|
  cards = named_card(player1, card)
  expect(cards).to_not be_empty

  @source = cards.send(index)
  expect(@source).to_not be_nil, "Could not find our #{index} card '#{card}'"
end

Then(/^our ([^ ]+) "([^"]*)" has the ability ([^ ]+)$/) do |index, card, ability|
  steps %Q{
    Then we have a #{index} "#{card}" in our battlefield
  }

  actions = @source.card.card_type.actions
  expect(actions).to include(ability), "Did not find ability '#{ability}' in #{actions}"

  @ability = AbilityAction.new(source: @source, key: ability)
end

Then(/^we can ([^ ]+) our ([^ ]+) "([^"]*)"$/) do |ability, index, card|
  steps %Q{
    Then our #{index} "#{card}" has the ability #{ability}
  }

  result = @ability.conditions.evaluate_with(duel)

  expect(result.evaluate).to be(true), result.explain
end

Then(/^we can not ([^ ]+) our ([^ ]+) "([^"]*)"$/) do |ability, index, card|
  steps %Q{
    Then our #{index} "#{card}" has the ability #{ability}
  }

  result = @ability.conditions.evaluate_with(duel)

  expect(result.evaluate).to be(false), result.explain
end

Then(/^we ([^ ]+) our ([^ ]+) "([^"]*)"$/) do |ability, index, card|
  steps %Q{
    Then we can #{ability} our #{index} "#{card}"
  }
  @ability.do(duel)
end

Then(/^our ([^ ]+) "([^"]*)" is not tapped$/) do |index, card|
  steps %Q{
    Then we have a #{index} "#{card}" in our battlefield
  }

  expect(@source.card).to_not be_tapped
end

Then(/^our ([^ ]+) "([^"]*)" is tapped$/) do |index, card|
  steps %Q{
    Then we have a #{index} "#{card}" in our battlefield
  }

  expect(@source.card).to be_tapped
end
