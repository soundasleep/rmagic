class UserController < ApplicationController
  before_filter :authenticate

  def show
    @user = user
  end

  private
    def user
      User.find(params[:id])
    end

end
