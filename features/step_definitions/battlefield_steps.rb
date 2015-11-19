Given(/^we have one "([^"]*)" on the battlefield$/) do |card|
  card = Library.new.find_card(card)

  game_driver.create_card player1.battlefield, card
end
