class UsersController < ApplicationController
  before_action :authenticate_user!

  # Only admins can see the full list of users
  def index
    redirect_to :back, alert: "Access denied." unless current_user.admin?
    @users = User.all
  end

  # Normal users can view their own show page (which is their Lucky 8 list).
  # Admin users can view any user's show page.
  def show
    @user = User.find(params[:id])
    if !current_user.admin? && @user != current_user
      redirect_to :back, :alert => "Access denied."
    end
  end

end
