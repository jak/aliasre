class UsersController < ApplicationController
  before_filter :authenticate_user!

  def index
    @users = User.all
    unless current_user.admin?
    	redirect_to root_path, alert: 'Access denied'
    end
  end

  def show
    @user = User.find(params[:id])
  end

end
