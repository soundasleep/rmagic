class WelcomeController < ApplicationController
  def index
  end

  helper_method :premade_decks

  private

    def premade_decks
      PremadeDeck.all
    end

end
