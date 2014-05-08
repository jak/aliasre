class UsersController < ApplicationController
  before_filter :authenticate_user!

  def index
  	redirect_to root_path, alert: 'Access denied'
  end

  def show
    redirect_to root_path, alert: 'Access denied'
    @user = User.find(params[:id])
  end

end
